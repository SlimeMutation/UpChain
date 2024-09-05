const { ethers, network, artifacts } = require("hardhat");
const hre = require("hardhat");
require('hardhat-abi-exporter');


async function main() {
  // await hre.run('compile');
  const MyToken = await hre.ethers.getContractFactory("MyToken");

  const myToken = await MyToken.deploy(10000);

  await myToken.waitForDeployment()

  const myTokenAddrsss = await myToken.getAddress();

  console.log("MyToken deployed to:", myTokenAddrsss);

  const Vault = await hre.ethers.getContractFactory("Vault");

  const vault = await Vault.deploy(myTokenAddrsss);

  await vault.waitForDeployment()

  const vaultAddrsss = await vault.getAddress();

  console.log("Vault deployed to:", vaultAddrsss);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });




