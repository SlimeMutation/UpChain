const { ethers, network, artifacts } = require("hardhat");
const hre = require("hardhat");
// require('hardhat-abi-exporter');


async function main() {
  // await hre.run('compile');
  const Bank = await hre.ethers.getContractFactory("Bank");

  const bank = await Bank.deploy();

  await bank.waitForDeployment()

  const bankAddrsss = await bank.getAddress();

  console.log("Bank deployed to:", bankAddrsss);

  console.log(`Please verify: npx hardhat verify ${bankAddrsss}` );

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });