// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/// @notice Educational state registry. Never receives or transfers funds.
/// @dev All amounts are whole simulated KZT. Bank statements are assertions,
/// not proof of an actual bank transfer. No personal data belongs on this ledger.
contract LeaseDeposit {
    enum Status { Draft, Signed, Funded, MoveOut, Disputed, ReleaseAuthorized, Settled }
    struct Lease {
        address landlord;
        address tenant;
        uint256 depositKzt;
        bytes32 agreementHash;
        bytes32 moveOutHash;
        uint256 responseDeadline;
        uint256 tenantKzt;
        uint256 landlordKzt;
        bool landlordSigned;
        bool tenantSigned;
        bool landlordNoClaims;
        bool tenantNoClaims;
        Status status;
    }
    address public immutable bank;
    address public immutable inspector;
    uint256 public constant RESPONSE_WINDOW = 7 days;
    uint256 public leaseCount;
    mapping(uint256 => Lease) private leases;
    mapping(bytes32 => bool) public usedSettlementReferences;

    event LeaseCreated(uint256 indexed id, address indexed landlord, address indexed tenant);
    event LeaseSigned(uint256 indexed id, address indexed party);
    event DepositConfirmed(uint256 indexed id);
    event MoveOutSubmitted(uint256 indexed id, uint256 responseDeadline);
    event NoClaimsConfirmed(uint256 indexed id, address indexed party);
    event DisputeOpened(uint256 indexed id, address indexed party);
    event ReleaseAuthorized(uint256 indexed id, uint256 tenantKzt, uint256 landlordKzt);
    event SettlementConfirmed(uint256 indexed id, bytes32 referenceHash);

    constructor(address bank_, address inspector_) {
        require(bank_ != address(0) && inspector_ != address(0) && bank_ != inspector_, "Invalid roles");
        bank = bank_;
        inspector = inspector_;
    }

    function getLease(uint256 id) external view returns (Lease memory) {
        return _lease(id);
    }

    function createLease(address tenant, uint256 depositKzt, bytes32 agreementHash) external returns (uint256 id) {
        require(tenant != address(0) && tenant != msg.sender, "Invalid tenant");
        require(msg.sender != bank && msg.sender != inspector && tenant != bank && tenant != inspector, "Role conflict");
        require(depositKzt > 0 && agreementHash != bytes32(0), "Invalid terms");
        id = ++leaseCount;
        Lease storage l = leases[id];
        l.landlord = msg.sender;
        l.tenant = tenant;
        l.depositKzt = depositKzt;
        l.agreementHash = agreementHash;
        emit LeaseCreated(id, msg.sender, tenant);
    }

    function signLease(uint256 id) external {
        Lease storage l = _lease(id);
        require(l.status == Status.Draft, "Wrong state");
        _party(l);
        if (msg.sender == l.landlord) {
            require(!l.landlordSigned, "Already signed");
            l.landlordSigned = true;
        } else {
            require(!l.tenantSigned, "Already signed");
            l.tenantSigned = true;
        }
        if (l.landlordSigned && l.tenantSigned) l.status = Status.Signed;
        emit LeaseSigned(id, msg.sender);
    }

    function confirmDeposit(uint256 id) external {
        require(msg.sender == bank, "Bank only");
        Lease storage l = _lease(id);
        require(l.status == Status.Signed, "Wrong state");
        l.status = Status.Funded;
        emit DepositConfirmed(id);
    }

    function submitMoveOut(uint256 id, bytes32 reportHash) external {
        Lease storage l = _lease(id);
        _party(l);
        require(l.status == Status.Funded, "Wrong state");
        require(reportHash != bytes32(0), "Empty report");
        l.moveOutHash = reportHash;
        l.responseDeadline = block.timestamp + RESPONSE_WINDOW;
        l.status = Status.MoveOut;
        emit MoveOutSubmitted(id, l.responseDeadline);
    }

    function confirmNoClaims(uint256 id) external {
        Lease storage l = _lease(id);
        _party(l);
        require(l.status == Status.MoveOut, "Wrong state");
        if (msg.sender == l.landlord) {
            require(!l.landlordNoClaims, "Already confirmed");
            l.landlordNoClaims = true;
        } else {
            require(!l.tenantNoClaims, "Already confirmed");
            l.tenantNoClaims = true;
        }
        emit NoClaimsConfirmed(id, msg.sender);
        if (l.landlordNoClaims && l.tenantNoClaims) _authorize(id, l, l.depositKzt);
    }

    function openDispute(uint256 id) external {
        Lease storage l = _lease(id);
        _party(l);
        require(l.status == Status.MoveOut, "Wrong state");
        require(block.timestamp < l.responseDeadline, "Response window closed");
        l.status = Status.Disputed;
        emit DisputeOpened(id, msg.sender);
    }

    function resolveDispute(uint256 id, uint256 tenantKzt) external {
        require(msg.sender == inspector, "Inspector only");
        Lease storage l = _lease(id);
        require(l.status == Status.Disputed, "Wrong state");
        require(tenantKzt <= l.depositKzt, "Allocation exceeds deposit");
        _authorize(id, l, tenantKzt);
    }

    /// @notice A transaction must invoke this; time passing alone executes nothing.
    function autoRelease(uint256 id) external {
        Lease storage l = _lease(id);
        require(l.status == Status.MoveOut, "Wrong state");
        require(block.timestamp >= l.responseDeadline, "Too early");
        // An explicit tenant confirmation is needed even if landlord is silent.
        require(l.tenantNoClaims, "Tenant confirmation required");
        _authorize(id, l, l.depositKzt);
    }

    /// @notice Mock bank acknowledgement, separate from release authorization.
    function confirmSettlement(uint256 id, bytes32 referenceHash) external {
        require(msg.sender == bank, "Bank only");
        Lease storage l = _lease(id);
        require(l.status == Status.ReleaseAuthorized, "Wrong state");
        require(referenceHash != bytes32(0) && !usedSettlementReferences[referenceHash], "Invalid reference");
        usedSettlementReferences[referenceHash] = true;
        l.status = Status.Settled;
        emit SettlementConfirmed(id, referenceHash);
    }

    function _authorize(uint256 id, Lease storage l, uint256 tenantKzt) private {
        l.tenantKzt = tenantKzt;
        l.landlordKzt = l.depositKzt - tenantKzt;
        l.status = Status.ReleaseAuthorized;
        emit ReleaseAuthorized(id, l.tenantKzt, l.landlordKzt);
    }

    function _lease(uint256 id) private view returns (Lease storage l) {
        require(id != 0 && id <= leaseCount, "Unknown lease");
        l = leases[id];
    }

    function _party(Lease storage l) private view {
        require(msg.sender == l.landlord || msg.sender == l.tenant, "Party only");
    }
}
