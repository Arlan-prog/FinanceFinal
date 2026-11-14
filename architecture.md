# Kepil architecture and review plan

## Selected direction

Target: a permissioned Besu consortium. Local prototype: Solidity 0.8.28 on Hardhat. The bank retains the hypothetical KZT deposits. Contract amounts are unsigned integers in whole KZT; they are not wei, Ether, token balances, revenue or spendable assets.

The target application would send authenticated requests through an API. The API submits transactions to Besu. Encrypted off-chain storage holds documents and reports; their hashes are referenced on-chain. A bank integration listens for release authorization, processes a payment off-chain and records an acknowledgement. None of the API, storage or bank integrations is implemented by this prototype.

## Roles

| Role | Allowed operations | Important limit |
|---|---|---|
| Landlord | Create lease, sign, submit move-out, confirm no claims, open dispute | Cannot confirm bank deposit or resolve dispute |
| Tenant | Sign, submit move-out, confirm no claims, open dispute | Cannot change agreed deposit |
| Bank | Confirm deposit and acknowledge settlement | Cannot authorize an allocation on its own |
| Inspector | Resolve an open dispute | Cannot resolve an undisputed lease |
| Any caller | Trigger eligible autoRelease, read on-chain data | No discretion over timed release amount |

Signing confirms the hash supplied at creation, intended to represent the agreement including the move-in evidence reference. Keys are test identities, not verified identities or legal signatures. All on-chain data is readable by observers with ledger access; access controls restrict writes, not confidentiality.

## States

1. Draft: landlord created immutable terms; signatures can be collected.
2. Signed: both parties signed; bank can confirm receipt.
3. Funded: mock bank confirmed the deposit.
4. MoveOut: one report recorded, deadline fixed; parties can confirm or dispute.
5. Disputed: timed and mutual no-claims release are blocked; inspector determines allocation.
6. ReleaseAuthorized: allocation is fixed; only bank acknowledgement remains.
7. Settled: acknowledgement recorded; cannot settle again.

MoveOut goes directly to ReleaseAuthorized when both parties confirm, or when tenant confirmation exists and the deadline has passed. Disputed goes to ReleaseAuthorized on an inspector decision. Allocation always adds to the original deposit. State transitions prevent repeated authorization and settlement. Reusing a settlement reference across leases is rejected.

## Approved validator ownership

On November 14, 2026, the user approved four independently controlled validators: one each for hypothetical Kepil, the partner bank, the inspection company and a consortium technical operator. The fourth organization is an explicit change from the three-organization Endterm design. QBFT is the proposed target consensus, not demonstrated by Hardhat. Four processes on one laptop do not demonstrate independent organizational control.

The technical operator's validator role provides no authority to confirm deposits, decide disputes or acknowledge settlement. Those application permissions remain separate from consensus participation. Validator admission/removal procedures, organizational agreements and key custody details still require specification.

Map hosting, monitoring, key management and governance for all four validators to the financial model. The approved educational estimates add KZT 1.2 million for setup/security integration in Year 0 and KZT 1.2 / 1.8 / 2.4 million for fourth-validator and security support in Years 1–3. These amounts are included in the financial model; they are not supplier quotes. The allocation among operators still requires agreement. Do not assume a lower development or audit budget merely because the platform changed.

## Threats and mitigation boundaries

| Threat | Prototype protection | Remaining work and budget connection |
|---|---|---|
| Unauthorized state change | Explicit sender checks and negative tests | Identity enrolment, key custody and recovery require design and cost allocation |
| Repeated or premature payout instruction | State checks, fixed deadline and unique bank reference | Bank API must implement idempotency and reconciliation; deployment integration work must cover it |
| False bank assertion or compromised inspector | Role separation and traceable events only | Independent reconciliation, review/appeal and key safeguards need governance and cost allocation |
| False or exposed evidence | Only invented hashes in tests | Hashes do not prove honesty; off-chain storage and consent are unimplemented |
| Network failure or collusion | No network-level protection demonstrated | Besu/QBFT integration and failure testing remain outstanding |

The Endterm already budgets an external audit at KZT 6.5 million, legal work at KZT 4 million, development/test infrastructure and tools at KZT 2 million, and operating infrastructure separately. These are existing assumptions, not verified quotes. Change the audit scope from Fabric to Solidity, API and integrations without assuming the original price remains valid. New protections must be allocated explicitly; do not double-count costs already included in development or operating infrastructure.

## Acceptance evidence

The automated test file covers the main path, role violations, missing/duplicate signatures, repeated deposits, invalid leases and inputs, deadline boundaries, dispute blocking, allocation conservation, and settlement replay. A successful run establishes only those tested local behaviors. It does not establish legal compliance, a completed security audit, bank integration, Besu compatibility or market demand.

## Next stage

The user approved explicit tenant no-claims confirmation for timed release on November 14, 2026. Validator ownership is also approved; governance procedures remain open. The approved additional estimates are included in the financial model and mapped to proposed controls in `risk-and-legal-analysis.md`. Team review responsibilities now follow the defense blocks listed in README. Instructor feedback asks for clear calculations, readiness for questions on every section and understanding of the fundamentals. Student profiles and declared contribution shares are in report Appendix D; individual accounts require each member’s review. Repository: https://github.com/Arlan-prog/FinanceFinal. Recorded demo: https://drive.google.com/file/d/1y6ScbQ-wPgfFQz3y9ex817yLJs_zvnVE/view?usp=drivesdk. Public video playback was verified without sign-in on 14 November 2026; duration 2:52. The unpacked repository files still need uploading.
