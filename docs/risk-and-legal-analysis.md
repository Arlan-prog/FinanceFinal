# Kepil risk assessment and legal analysis

Review date: 14 November 2026. Educational simulation. All partners, customers, transactions and commercial estimates are hypothetical. This analysis does not establish permission to operate a real financial service.

## Scope and findings

Kepil's core risks are commercial adoption, dependence on a bank and the gap between a tested local contract and an operating escrow service. The prototype records authorizations; it cannot force a bank to transfer KZT or prove that a bank acknowledgement is true. Four independent validators reduce concentration in the target design, but do not make the bank, inspector or off-chain evidence trustworthy by themselves.

Conditional agency-first base: revenue 13.53 / 60.64 / 121.04m KZT; net income -14.22 / 12.64 / 47.12m; NPV at 20% 6.20m; peak monthly funding 34.93m; undiscounted payback 2.42 operating years after six-month prelaunch. Profit is a conditional forecast, not actual earnings or validated demand. Lower conversion or higher costs can make NPV negative. No survey responses, paying clients, bank agreement or production Besu deployment are claimed. Paid founder and staff costs, tax, bank fees, security and administrative allowances are included. Receipts occur in the service month; annual CIT is allocated evenly monthly for liquidity planning, not a statutory tax schedule.

## Risk assessment method

Likelihood and impact are qualitative planning judgments, not measured probabilities. High likelihood means the risk is directly supported by an unresolved dependency or by the forecast. Medium means a credible exposure exists without evidence establishing frequency. High impact means the event can block the service, materially impair funding, compromise funds or expose sensitive data; medium impact means a recoverable operational or commercial loss. Ratings describe the present design before unimplemented controls. Planned controls do not count as completed mitigation.

Table 1. Kepil risk register

| ID and category | Event and consequence | Likelihood | Impact | Response and evidence required | Hypothetical owner | Budget link |
|---|---|---|---|---|---|---|
| R1 Market | Landlords decline escrow; tenants cannot adopt alone | High | High | Anonymous consent-based research; measure willingness to pay; no claimed pilots or signed clients | Commercial lead | B5 and existing staff |
| R2 Market | B2B cohorts fail to convert or retain paying accounts | High | High | Track average paying subscribers, retention and acquisition costs; test conversion, zero B2B adoption and combined downside | Commercial lead / finance lead | B5 and existing staff |
| R3 Bank dependency | No bank offers the assumed product, API or KZT 500 fee | High | High | Treat bank partnership as a prerequisite; hypothetical terms must cover permissions, reconciliation and failure handling | Operations / legal lead | B1, B3, B4, B6 |
| R4 Security | Unauthorized transition or repeat release authorization | Medium | High | Current sender/state checks and negative unit tests; independent audit before any hypothetical production launch | Technical lead | B1 and B2 |
| R5 Security | Bank or inspector key is compromised | Medium | High | Separate custody, approvals, recovery and revocation design; current immutable-role prototype lacks recovery and pause | Security lead | B1, B6, B7 |
| R6 Operational | Contract authorizes payment but bank fails, retries or falsely acknowledges | Medium | High | Idempotent bank requests, independent reconciliation and unresolved-payment queue; current acknowledgement is only a mock | Operations lead | B1, B6, B7 |
| R7 Network | Validator outage, common hosting failure or collusion | Medium | High | Independent operators and fault domains; monitor, back up and test failures; Hardhat does not demonstrate QBFT resilience | Consortium technical operator | B4, B6, B7 |
| R8 Data protection | Photos, identifiers, logs or backups leak | Medium | High | Minimize collection, encrypt off-chain records, define access/retention, test deletion and incident procedures | Security / legal lead | B1, B3, B4, B7 |
| R9 Evidence and disputes | False report, biased inspector or ambiguous wear-and-tear criteria | Medium | High | Agreed inspection criteria, conflict checks, reasoned decision and complaint/escalation route; a hash only detects changes | Inspection / legal lead | B3 and existing staff |
| R10 Financial | Cash runs out before the forecast ends | High | High | Monthly cash review; stage commitments against evidence of demand; obtain a team decision on funding or scope | Finance lead | Existing finance staff; no additional funding assumed |
| R11 Regulatory and tax | Actual service classification or tax treatment differs from assumptions | Medium | High | Review escrow, payment-service perimeter, digital assets, signatures, data and tax before hypothetical launch | Legal / finance lead | B3 and existing other opex |
| R12 Supply chain | Toolchain dependency vulnerability or insecure upgrade | Medium | Medium | Pin versions, review advisories, patch and rerun tests; do not expose local development tools publicly | Technical lead | B1 and B7 |

Source: project-specific assessment based on the supplied Endterm, the current prototype and the updated financial model. Proposed owners are roles, not assigned team members.

Table 1 distinguishes implemented checks from planned controls. The 23 passing tests provide local behavioral evidence for selected contract paths. They do not verify a bank connection, privacy compliance, key recovery, an external audit or a Besu deployment. The previously observed Hardhat/Zod advisory is a tooling issue; it is not evidence of an exploitable flaw in the Solidity contract.

## Revised lean mitigation budget

Table 2. Risk allowances, KZT million; included once in model costs

| ID | Scope | Year 0 | Year 1 | Year 2 | Year 3 |
|---|---|---:|---:|---:|---:|
| B1 | Paid development/product | 8.10 | — | — | — |
| B2 | Scoped security review | 3.00 | — | — | — |
| B3 | Legal/bank feasibility | 2.00 | — | — | — |
| B4 | Tools / operating hosting | 0.90 | 1.20 | 1.80 | 2.40 |
| B5 | Discovery / B2B outreach | 0.60 | 2.40 | 4.80 | 4.80 |
| B6 | Integration contingency | 3.40 | — | — | — |
| B7 | Security/operator allowance | — | 1.20 | 1.80 | 2.40 |

Source: revised scope estimates, 16 November 2026; not supplier quotations. Setup totals 18m, with 22m liquidity/reserve in the hypothetical 40m envelope. The first 5.6m gate is included, not additional. Paid payroll is 20.40 / 30.69 / 42.834m annually. Shared allowances are not multiplied by risks.

Key recovery, reconciliation, monitoring and backup procedures are proposed uses of these allowances. Their inclusion is not proof that the allowance is sufficient or the controls exist. Unexpected litigation, a regulatory licence requirement or materially higher vendor prices would require a revised budget and decision. The project does not assume purchasing insurance or completing a certification.

## Banking escrow and payment-service perimeter

The Law on Payments and Payment Systems defines an escrow account as a bank account subject to conditions restricting expenditure. This supports considering a bank-controlled escrow structure, but does not establish that a bank offers Kepil's exact rental product or accepts contract events as payment instructions. The bank-account terms must specify parties, release conditions, refunds and dispute handling. [Republic of Kazakhstan, 2016, Law No. 11-VI](https://old.adilet.zan.kz/rus/docs/Z1600000011/compare/kaz).

For Kepil, the proposed boundary is that the bank holds all deposits and executes payments; Kepil supplies software, records and proposed release authorizations. This is a design intention, not a legal classification. A hypothetical legal review must examine whether the API flow constitutes a regulated payment service, what registrations or permissions are required and how the bank's identity and financial-crime controls interact with the service. Never state that a partner bank's licence automatically covers every activity of Kepil. Do not describe client deposits as Kepil revenue, financing or cash reserve.

## Digital assets and AIFC

The national digital-asset framework changed in 2026. The National Bank describes amended rules and activity-specific categories of digital-asset providers. Therefore, a broad statement that every digital-asset activity is confined to AIFC would be unsafe without checking the current activity and legislation. [National Bank of Kazakhstan, n.d., Regulatory framework for the digital asset market](https://nationalbank.kz/ru/page/digital-assets-legal-framework).

Kepil currently issues no transferable token or tokenized claim. Its Solidity deposit amount is an accounting field, not an issued financial asset. This supports an inference that token-issuance rules may not be the primary regulatory issue; it does not establish a statutory exemption. Any later token, stablecoin, custody or trading feature would require a new perimeter analysis. The governing national law is [Law No. 193-VII of 6 February 2023](https://old.adilet.zan.kz/rus/docs/Z2300000193/info); article-specific conclusions must be checked against its current consolidated text.

AFSA maintains separate rules for digital-asset trading facilities, service providers and certain money-service activities. Using Besu does not itself make Kepil an AIFC participant or authorised firm. AIFC is a regime to analyse if the proposed entity and activities enter its jurisdiction, not a generic permission to operate. [AFSA, 2026 effective rules, AIFC Rules on Digital Asset Activities](https://orderly.myafsa.com/articles/aifc-rules-on-digital-asset-activities).

## Personal data and evidence

Kazakhstan's personal-data law addresses consent, access, storage and cross-border transfer. Article 12 requires local storage as specified by the law; Article 16 governs cross-border transfers. An off-chain design should therefore include local hosting, access controls, retention and deletion rules, and review of foreign backups or support access. Encryption alone is not proof of compliance. [Republic of Kazakhstan, 2013, Law No. 94-V](https://old.adilet.zan.kz/rus/docs/Z1300000094/compare); [official government-hosted text](https://www.gov.kz/org/telecom/documents/details/175?lang=ru).

Application to Kepil: use invented data in the course prototype. In the hypothetical production design, store evidence off-chain and avoid publishing identifiers, addresses or raw photos on the ledger. A hash or blockchain address can remain linkable to an identifiable person; “hashed” must not be treated as automatically anonymous. Define responsibility among Kepil, the bank and the inspector, document access and consent, and address immutable references when the underlying document must be removed. These are proposed controls requiring implementation and legal review.

## Electronic signatures and enforceability

The 2026 Digital Code is relevant at the review date. Its Article 49 attaches legal equivalence to electronic digital signatures satisfying specified conditions, including certificate-related requirements. A transaction signed by a Hardhat test account does not, by itself, demonstrate those conditions. [Republic of Kazakhstan, 2026, Digital Code No. 255-VIII](https://old.adilet.zan.kz/rus/docs/K2600000255); [government notice of entry into force](https://www.gov.kz/org/zhetysu-karatal/press/news/details/1258715?lang=ru).

Kepil therefore needs a distinction between application authorization and legally effective agreement. A hypothetical service should use an appropriate document/signature process and link the agreed document to its hash. Seven-day silence, inspection authority and the distinction between ordinary wear and damage must be reflected in agreed terms. The inspector's contract action is not automatically a court judgment or an arbitral award. The legal effect of the specific release terms and the available complaint/court route remain matters for review, not claims established by tests.

## Legal form and intellectual property

A Kazakhstan LLP (ТОО) is a proposed legal form for a hypothetical operating company because it supports participants holding interests. This is a recommendation for the business design, not a company registration or a confirmed allocation of ownership. The team must still decide governance and any investment equity terms. [Republic of Kazakhstan, 1998, Law No. 220-I, official government-hosted text](https://www.gov.kz/org/maidd/documents/details/3947?lang=ru).

The Ministry of Justice lists computer programs as copyright objects. For Kepil, maintain a record of contributors, obtain appropriate rights to commissioned work and comply with third-party licences. Consider a trademark search for the brand before any hypothetical commercial use. Do not claim that the concept itself is patented, that a trademark is registered or that all generated code automatically has exclusive rights. [Ministry of Justice, n.d., Intellectual property](https://www.gov.kz/org/adilet/activities/211?lang=ru).

## Accounting and tax assumptions

IAS 38 distinguishes research expenditure from development expenditure meeting recognition criteria. With no evidence demonstrating those criteria for Kepil, the educational model expenses development and startup costs in Year 0. No corresponding intangible asset or amortization is invented. This is a modeling judgment, not a conclusion about every future cost. [IFRS Foundation, n.d., IAS 38 Intangible Assets](https://www.ifrs.org/issued-standards/list-of-standards/ias-38-intangible-assets/).

Government guidance identifies base CIT of 20% and VAT of 16% under the new Tax Code. The model uses final VAT-inclusive prices, registration from launch, all modeled Kepil fees treated as taxable and no input-credit benefit. These last assumptions are conservative simplifications, not verified mandatory treatment of this exact service. Corporate income tax is calculated on positive modeled profit; the revised base incurs CIT in profitable years. A book loss does not universally prove zero tax in a real business. [Ministry of National Economy, 2025, New Tax Code announcement](https://www.gov.kz/org/economy/press/news/details/1036878?lang=ru).

The actual VAT registration point depends on applicable rules and turnover. Official 2026 guidance refers to a 10,000-MRP threshold for the general regime; the model does not claim that voluntary registration at launch is mandatory. No calendar start date or future MRP values are invented. A future implementation must verify taxability, input credits, deductible costs and filing/payment timing. [State Revenue Department, 2026, Exceeding the mandatory VAT registration threshold](https://www.gov.kz/org/kgd-alm/press/news/details/1285755).

## Verification limits and next decisions

This review used official government, regulator and standards-setter sources. Some Adilet full-text pages returned access errors; the linked indexed official extracts or government-hosted copies support only the propositions stated. An article-by-article current consolidated legal opinion has not been completed. No unverified licence fee, bank tariff or legal exemption has been inserted.

Hypothetical funding envelope: 40m KZT, comprising 18m prelaunch and 22m liquidity/reserve. Base headroom above peak need: 5.07m. Commit only 5.6m for the first two-month feasibility gate initially. The former separate 12m study and 230m launch ask are superseded. Illustrative 20% equity implies 200m post-money / 160m pre-money; these are negotiation terms, not a validated valuation.

## AI Disclosure Statement

OpenAI Codex (GPT-6) assisted with research, presentation preparation, and project development. The team takes responsibility for managing the project, reviewing its processes, and verifying and explaining the calculation logic, assumptions, and final results. All commercial conversion rates and study costs remain hypothetical. No customer responses were generated as research evidence.
