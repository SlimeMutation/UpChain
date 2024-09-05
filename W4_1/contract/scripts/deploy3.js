const { ethers, network, artifacts } = require("hardhat");
const hre = require("hardhat");
require('hardhat-abi-exporter');


async function main() {
  // await hre.run('compile');
  const MyToken = await hre.ethers.getContractFactory("MyERC721");

  const myToken = await MyToken.deploy();

  await myToken.waitForDeployment()

  const myTokenAddrsss = await myToken.getAddress();

  console.log("MyERC721 deployed to:", myTokenAddrsss);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });




