Educational project for the course Introduction to Finance. Not a real product, service or investment offer. Do not use with real funds.

# Kepil local prototype

Kepil models a rental deposit held by a hypothetical bank. Solidity records the lease lifecycle and authorizes an allocation. It does not receive cryptocurrency, transfer KZT, connect to a bank, or prove that a bank paid anyone. All test data is invented.

## Project links

- [GitHub repository](https://github.com/Arlan-prog/FinanceFinal)
- [Recorded prototype demo](https://drive.google.com/file/d/1y6ScbQ-wPgfFQz3y9ex817yLJs_zvnVE/view?usp=drivesdk)

## Status and scope

The selected target architecture is permissioned Besu with four validators independently operated by four hypothetical organizations: Kepil, the partner bank, the inspection company and a consortium technical operator. This change from the three-organization Endterm design was approved on November 14, 2026. The runnable prototype uses a local Hardhat network. No Besu network or QBFT fault tolerance has been tested here. Validator status does not confer bank or inspector permissions in the application contract.

This is a draft core-use-case prototype for review. It implements signatures, bank deposit confirmation, move-out, mutual no-claims release, disputes, a timed release path and a separate mock bank settlement acknowledgement. Holdback, partial interim settlement, contract cancellation, key rotation, pause controls, notifications, document storage and a bank API are not implemented.

## Run locally

Use Node.js 22.13.0 or later (this workspace uses Node.js 24.11.0).

```sh
npm ci
npm run build
npm test
npm run demo
```

The first compilation downloads Solidity 0.8.28. The demo creates an ephemeral local Hardhat network and uses its test accounts. It prints no private keys. No wallet, public testnet, faucet, payment or API key is needed. The demo refuses a chain ID other than 31337; the project has no remote network configuration.

The tests are Solidity tests run by Hardhat. `contracts/LeaseDeposit.t.sol` defines a small cheatcode interface for simulated callers and time changes; no external contract template is copied into the application contract. Compiler EVM target is Paris; deployment to any particular Besu configuration still requires compatibility testing.

## Files

Verified on November 14, 2026: Solidity compilation succeeded, all 23 unit tests passed, and the scripted local deployment-to-settlement demonstration completed successfully. The team has recorded the narrated demo; the video is linked below.

- `contracts/LeaseDeposit.sol`: application contract.
- `contracts/LeaseDeposit.t.sol`: unit tests.
- `scripts/demo.ts`: deployment and the no-claims main use case.
- `docs/architecture.md`: roles, states, limitations and decisions for review.
- `outputs/kepil-finance/Kepil_Financial_Model.xlsx`: VAT-inclusive financial forecast, income statement, cash flow and sensitivity analysis.
- `docs/risk-and-legal-analysis.md`: risk register, mitigation budgets and sourced Kazakhstan legal analysis.
- `outputs/report/Final_Project_Report.docx` and `.pdf`: assembled report; main text is 15 pages, with team responsibilities, source checks and final disclosure.

## Review decisions

The tenant-confirmation condition below is approved. Other detailed implementation choices remain available for review:

1. Either party may submit one move-out report; this starts the seven-day response window. There is no lease-end-date enforcement in this minimal version.
2. Timed release requires explicit tenant no-claims confirmation. The user approved this additional condition on November 14, 2026. It protects against releasing after an unacknowledged landlord-submitted report.
3. Disputes can be opened before the deadline; autoRelease is allowed at or after the deadline. No-claims confirmation remains possible after the deadline while the lease is still in MoveOut.
4. Any caller can invoke autoRelease once its conditions hold. Time alone never executes it. A future notification/scheduler service needs a budget and operational plan.
5. Bank and inspector are immutable demonstration roles. They cannot be lease parties. Production role replacement and conflict-of-interest controls are out of scope.

Distinguish the approved tenant-confirmation condition from the remaining detailed implementation choices.

## Submission fields

- Submission name: Final Project (no team number assigned).
- GitHub repository: [Arlan-prog/FinanceFinal](https://github.com/Arlan-prog/FinanceFinal).
- Demo video: [Watch the recorded demonstration](https://drive.google.com/file/d/1y6ScbQ-wPgfFQz3y9ex817yLJs_zvnVE/view?usp=drivesdk).
- Supervisor according to supplied requirements: Nurkhat Ibadildin, Associate Professor.

Each team member must commit their own actual contribution from their own account. This workspace does not fabricate contribution history. The recorded demo should show deployment, the main use case and passing tests within three minutes. Public video playback was verified without Google sign-in on 14 November 2026 (duration 2:52). Upload the unpacked repository files before submission.

## Team review and defense responsibilities

These assignments follow the agreed defense blocks and identify responsibility for final review and explanation. They do not establish past authorship or individual contribution percentages.

| Member | Main slides | Report pages | Review area |
| --- | --- | --- | --- |
| Ardak Akytuly | 1–4 | 1–4 | Product, business model and architecture |
| Aituar Taibulat | 5–6 | 5–6, 21 | Prototype, tests and security |
| Akylzhan Uvazyrov | 7–9 | 10–14, 20 | Financial calculations and sensitivity |
| Marlen Yerkinbayev | 10–12 | 7–9, 15–16, 22 | Risk, legal analysis and investment ask |
| Galymzhan Nygmat | 13–15 | 17–19, 23–24 | Conclusions, references and disclosure |

Backup slides: Galymzhan 16–18 (references); Akylzhan 19 (calculations); Marlen 20 (risk register).

Instructor feedback was to present calculations clearly, prepare to answer questions on any section, and study the project fundamentals. The response is a calculation guide in Appendix A, explicit financial assumptions, and cross-topic preparation for all five members. Team lead and recorded-demo author: Ardak Akytuly. Declared contribution shares: Ardak 40%, Aituar 10%, Akylzhan 16⅔%, Marlen 16⅔%, Galymzhan 16⅔% (100% total). Brief student profiles are in report Appendix D. Individual self-evaluations are submitted separately in Moodle and are not included in the GitHub upload package. Each student must review their own account before submission.

## Security limitations

The bank can make a false deposit or settlement assertion. A hash cannot establish truth, consent, a lawful entitlement or physical property condition. A compromised inspector key can assign the entire deposit to either party in a disputed lease. There is no emergency pause or role recovery. There are no external calls or currency transfers in the application contract; a reentrancy guard would not address the principal risks of this particular registry.

Dependencies are pinned by package-lock.json. At initial installation, updating ethers to 6.17.0 removed its reported ws-related findings. Three high-severity npm audit entries remain in the Hardhat/zod dependency chain (one underlying Zod advisory, GHSA-mrhx-c7xc-m3w5). Hardhat currently requires Zod 3; forcing a major Zod replacement or a major Hardhat downgrade is not treated as a safe automatic fix. This is a local educational toolchain, not an audited production deployment. Recheck `npm audit` before sharing or extending it.

## Source and video verification

All five academic journals were matched to Elsevier’s official October 2026 Scopus source list. Each cited publication year falls within its journal coverage. Public video playback was verified without sign-in; duration is 2:52. The defense plan is 9:37 with 23 seconds reserved for transitions. Evidence and exact source IDs are in `docs/verification.txt`.

## References

- Nomic Foundation. (n.d.). Getting started with Hardhat 3. https://hardhat.org/docs/getting-started (accessed November 14, 2026).
- Nomic Foundation. (n.d.). Writing unit tests in Solidity. https://hardhat.org/docs/guides/testing/using-solidity (accessed November 14, 2026).
- Besu contributors. (n.d.). Configure QBFT consensus. https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft (accessed November 14, 2026).
- Besu contributors. (n.d.). Configure free gas networks. https://docs.besu-eth.org/private-networks/how-to/configure/free-gas (accessed November 14, 2026).
- Besu contributors. (2026). Permissioning. https://docs.besu-eth.org/private-networks/concepts/permissioning (accessed November 14, 2026).

These are technical documentation sources, not Scopus journal papers.

## AI Disclosure Statement

We used OpenAI Codex to support research, coding, financial modelling, and the preparation of project materials. Our team selected the project approach, approved the assumptions, and studied the material independently. We take responsibility for the submitted work and for explaining our decisions, calculations, and prototype during the defense.
