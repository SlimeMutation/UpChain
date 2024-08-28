const { ethers, network, artifacts } = require("hardhat");
const hre = require("hardhat");
// require('hardhat-abi-exporter');


async function main() {
  // await hre.run('compile');
  const Counter = await hre.ethers.getContractFactory("Score");

  const counter = await Counter.deploy(0);

  await counter.waitForDeployment()

  const counterAddrsss = await counter.getAddress();

  console.log("Counter deployed to:", counterAddrsss);

  let tx = await counter.count();
  await tx.wait();

  let Artifact = await artifacts.readArtifact("Counter");
  await writeAbiAddr(Artifact, counterAddrsss, "Counter", network.name);

  console.log(`Please verify: npx hardhat verify ${counterAddrsss}` );

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });




