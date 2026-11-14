import { network, artifacts } from "hardhat";
import { BrowserProvider, ContractFactory, keccak256, toUtf8Bytes } from "ethers";

const connection = await network.create();
try {
  const provider = new BrowserProvider(connection.provider);
  const chain = await provider.getNetwork();
  if (chain.chainId !== 31337n) throw new Error("Demo restricted to the local Hardhat chain");
  const [bank, inspector, landlord, tenant] = await Promise.all([0, 1, 2, 3].map(i => provider.getSigner(i)));
  const artifact = await artifacts.readArtifact("LeaseDeposit");
  const c = await new ContractFactory(artifact.abi, artifact.bytecode, bank).deploy(await bank.getAddress(), await inspector.getAddress());
  await c.waitForDeployment();
  const hash = (value: string) => keccak256(toUtf8Bytes(value));
  const tx = async (label: string, promise: any) => { await (await promise).wait(); console.log(label); };
  console.log("Educational local simulation. All amounts are fictitious KZT; no funds move.");
  console.log("Deployed LeaseDeposit:", await c.getAddress());
  await tx("1. Landlord creates a lease for 150,000 simulated KZT", c.connect(landlord).createLease(await tenant.getAddress(), 150000, hash("invented lease and move-in report")));
  await tx("2. Landlord signs", c.connect(landlord).signLease(1));
  await tx("3. Tenant signs", c.connect(tenant).signLease(1));
  await tx("4. Mock bank confirms deposit", c.connect(bank).confirmDeposit(1));
  await tx("5. Tenant submits move-out report hash", c.connect(tenant).submitMoveOut(1, hash("invented move-out report")));
  await tx("6. Tenant confirms no claims", c.connect(tenant).confirmNoClaims(1));
  await tx("7. Landlord confirms no claims; release is authorized", c.connect(landlord).confirmNoClaims(1));
  const before = await c.getLease(1);
  if (before.status !== 5n || before.tenantKzt !== 150000n || before.landlordKzt !== 0n) throw new Error("Unexpected allocation");
  console.log("Authorized allocation: tenant 150,000 KZT; landlord 0 KZT. Bank acknowledgement still required.");
  await tx("8. Mock bank acknowledges settlement", c.connect(bank).confirmSettlement(1, hash("invented bank reference 1")));
  if ((await c.getLease(1)).status !== 6n) throw new Error("Settlement not recorded");
  console.log("PASS: lease settled. No real bank connection or cryptocurrency payment.");
} finally {
  await connection.close();
}
