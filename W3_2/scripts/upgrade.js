// scripts/upgrade.js
async function main() {
  const { ethers, upgrades } = require("hardhat");

  const existingProxyAddress = '0xB6f64daFC2A7a035237bF76357Ff9714992D9a50';
  const MyERC20V2 = await ethers.getContractFactory("MyTokenV2");
  console.log("Upgrading to MyERC20V2...");
  const myERC20 = await upgrades.upgradeProxy(existingProxyAddress, MyERC20V2);
  // await myERC20.waitForDeployment();
  const myERC20Addrsss = await myERC20.getAddress();
  console.log("MyERC20 upgraded to:", myERC20Addrsss);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
