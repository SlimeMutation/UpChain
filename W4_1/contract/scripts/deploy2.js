const { ethers, network, artifacts } = require("hardhat");
const hre = require("hardhat");
require('hardhat-abi-exporter');


async function main() {
  // await hre.run('compile');
  const MyToken = await hre.ethers.getContractFactory("ERC2612");

  const myToken = await MyToken.deploy();

  await myToken.waitForDeployment()

  const myTokenAddrsss = await myToken.getAddress();

  console.log("ERC2612 deployed to:", myTokenAddrsss);

  const Vault = await hre.ethers.getContractFactory("Bank");

  const vault = await Vault.deploy(myTokenAddrsss);

  await vault.waitForDeployment()

  const vaultAddrsss = await vault.getAddress();

  console.log("Bank deployed to:", vaultAddrsss);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });




