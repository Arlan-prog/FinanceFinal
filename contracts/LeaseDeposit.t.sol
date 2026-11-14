// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {LeaseDeposit} from "./LeaseDeposit.sol";

interface Vm {
    function prank(address) external;
    function warp(uint256) external;
    function expectRevert(bytes calldata) external;
}

contract LeaseDepositTest {
    Vm constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant BANK = address(0x1001);
    address constant INSPECTOR = address(0x1002);
    address constant LANDLORD = address(0x1003);
    address constant TENANT = address(0x1004);
    address constant OUTSIDER = address(0x1005);
    LeaseDeposit c;

    function setUp() public { c = new LeaseDeposit(BANK, INSPECTOR); }
    function draft() internal returns (uint256 id) {
        vm.prank(LANDLORD);
        id = c.createLease(TENANT, 150000, keccak256("invented agreement"));
    }
    function signedLease() internal returns (uint256 id) {
        id = draft();
        vm.prank(LANDLORD); c.signLease(id);
        vm.prank(TENANT); c.signLease(id);
    }
    function funded() internal returns (uint256 id) {
        id = signedLease();
        vm.prank(BANK); c.confirmDeposit(id);
    }
    function movedOut() internal returns (uint256 id) {
        id = funded();
        vm.prank(TENANT); c.submitMoveOut(id, keccak256("invented report"));
    }
    function authorized() internal returns (uint256 id) {
        id = movedOut();
        vm.prank(TENANT); c.confirmNoClaims(id);
        vm.prank(LANDLORD); c.confirmNoClaims(id);
    }
    function testHappyPathSeparatesAuthorizationFromSettlement() public {
        uint256 id = authorized();
        LeaseDeposit.Lease memory l = c.getLease(id);
        require(l.status == LeaseDeposit.Status.ReleaseAuthorized, "Must await bank");
        require(l.tenantKzt == 150000 && l.landlordKzt == 0, "Allocation");
        vm.prank(BANK); c.confirmSettlement(id, keccak256("mock payment 1"));
        require(c.getLease(id).status == LeaseDeposit.Status.Settled, "Not settled");
    }
    function testBankCannotFundBeforeBothSign() public {
        uint256 id = draft();
        vm.prank(TENANT); c.signLease(id);
        vm.expectRevert(bytes("Wrong state"));
        vm.prank(BANK); c.confirmDeposit(id);
    }
    function testOutsiderCannotSign() public {
        uint256 id = draft();
        vm.expectRevert(bytes("Party only")); vm.prank(OUTSIDER); c.signLease(id);
    }
    function testOnlyBankConfirmsDeposit() public {
        uint256 id = signedLease();
        vm.expectRevert(bytes("Bank only")); vm.prank(LANDLORD); c.confirmDeposit(id);
    }
    function testDuplicateSignatureRejected() public {
        uint256 id = draft();
        vm.prank(TENANT); c.signLease(id);
        vm.expectRevert(bytes("Already signed")); vm.prank(TENANT); c.signLease(id);
    }
    function testDepositCannotBeConfirmedTwice() public {
        uint256 id = funded();
        vm.expectRevert(bytes("Wrong state")); vm.prank(BANK); c.confirmDeposit(id);
    }
    function testMoveOutCannotResetDeadline() public {
        uint256 id = movedOut();
        vm.expectRevert(bytes("Wrong state")); vm.prank(LANDLORD); c.submitMoveOut(id, keccak256("replacement"));
    }
    function testOutsiderCannotSubmitMoveOut() public {
        uint256 id = funded();
        vm.expectRevert(bytes("Party only")); vm.prank(OUTSIDER); c.submitMoveOut(id, keccak256("report"));
    }
    function testSingleConfirmationDoesNotAuthorize() public {
        uint256 id = movedOut();
        vm.prank(TENANT); c.confirmNoClaims(id);
        require(c.getLease(id).status == LeaseDeposit.Status.MoveOut, "Premature release");
    }
    function testAutoReleaseBeforeDeadlineRejected() public {
        uint256 id = movedOut();
        vm.prank(TENANT); c.confirmNoClaims(id);
        vm.warp(c.getLease(id).responseDeadline - 1);
        vm.expectRevert(bytes("Too early")); c.autoRelease(id);
    }
    function testAutoReleaseAtDeadlineWorks() public {
        uint256 id = movedOut();
        vm.prank(TENANT); c.confirmNoClaims(id);
        vm.warp(c.getLease(id).responseDeadline);
        vm.prank(OUTSIDER); c.autoRelease(id);
        require(c.getLease(id).tenantKzt == 150000, "Refund amount");
    }
    function testAutoReleaseNeedsTenantConfirmation() public {
        uint256 id = movedOut();
        vm.warp(c.getLease(id).responseDeadline);
        vm.expectRevert(bytes("Tenant confirmation required")); c.autoRelease(id);
    }
    function testDisputeBlocksAutoRelease() public {
        uint256 id = movedOut();
        vm.prank(TENANT); c.confirmNoClaims(id);
        vm.prank(LANDLORD); c.openDispute(id);
        vm.warp(c.getLease(id).responseDeadline);
        vm.expectRevert(bytes("Wrong state")); c.autoRelease(id);
    }
    function testDisputeAtDeadlineRejected() public {
        uint256 id = movedOut();
        vm.warp(c.getLease(id).responseDeadline);
        vm.expectRevert(bytes("Response window closed")); vm.prank(LANDLORD); c.openDispute(id);
    }
    function testOnlyInspectorResolves() public {
        uint256 id = movedOut();
        vm.prank(LANDLORD); c.openDispute(id);
        vm.expectRevert(bytes("Inspector only")); vm.prank(BANK); c.resolveDispute(id, 100000);
    }
    function testDisputeSplitConservesDeposit() public {
        uint256 id = movedOut();
        vm.prank(LANDLORD); c.openDispute(id);
        vm.prank(INSPECTOR); c.resolveDispute(id, 120000);
        LeaseDeposit.Lease memory l = c.getLease(id);
        require(l.tenantKzt == 120000 && l.landlordKzt == 30000, "Split");
        require(l.tenantKzt + l.landlordKzt == l.depositKzt, "Conservation");
    }
    function testExcessiveAllocationRejected() public {
        uint256 id = movedOut();
        vm.prank(LANDLORD); c.openDispute(id);
        vm.expectRevert(bytes("Allocation exceeds deposit")); vm.prank(INSPECTOR); c.resolveDispute(id, 150001);
    }
    function testOnlyBankConfirmsSettlement() public {
        uint256 id = authorized();
        vm.expectRevert(bytes("Bank only")); vm.prank(TENANT); c.confirmSettlement(id, keccak256("payment"));
    }
    function testSettlementCannotBeRepeated() public {
        uint256 id = authorized();
        vm.prank(BANK); c.confirmSettlement(id, keccak256("payment"));
        vm.expectRevert(bytes("Wrong state")); vm.prank(BANK); c.confirmSettlement(id, keccak256("payment2"));
    }
    function testSettlementReferenceCannotBeReused() public {
        uint256 first = authorized(); uint256 second = authorized();
        vm.prank(BANK); c.confirmSettlement(first, keccak256("same payment"));
        vm.expectRevert(bytes("Invalid reference")); vm.prank(BANK); c.confirmSettlement(second, keccak256("same payment"));
    }
    function testUnknownLeaseRejected() public {
        vm.expectRevert(bytes("Unknown lease")); c.getLease(1);
    }
    function testZeroDepositRejected() public {
        vm.expectRevert(bytes("Invalid terms")); vm.prank(LANDLORD); c.createLease(TENANT, 0, keccak256("agreement"));
    }
    function testBankCannotBeTenant() public {
        vm.expectRevert(bytes("Role conflict")); vm.prank(LANDLORD); c.createLease(BANK, 150000, keccak256("agreement"));
    }
}
