// scripts/deploy.js
async function main() {
  const { ethers, upgrades } = require("hardhat");

  const MyERC20 = await ethers.getContractFactory("MyToken");
  console.log("Deploying MyERC20...");
  const myERC20 = await upgrades.deployProxy(MyERC20, ["My Token", "MTK", 1000000], { initializer: 'initialize' });
  await myERC20.waitForDeployment();
  const myERC20Addrsss = await myERC20.getAddress();
  console.log("MyERC20 deployed to:", myERC20Addrsss);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
