let { ethers } = require("hardhat");
const delay = require('./delay.js');

let sushi, masterChef, myToken, myTokenMarket;

let uniwapRouter = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9";

async function deploySushi() {
    let SushiToken = await ethers.getContractFactory("SushiToken");
    sushi = await SushiToken.deploy();
    await sushi.waitForDeployment();
  
    console.log("sushi: " + await sushi.getAddress());
}

async function deployMasterChef() {
    let MasterChef = await ethers.getContractFactory("MasterChef");
    let award = ethers.parseUnits("40", 18);
    masterChef = await MasterChef.deploy(sushi.getAddress(), award, 10);
    await masterChef.waitForDeployment();
  
    console.log("masterChef: " + await masterChef.getAddress());
}

async function deployMyToken() {
    let MyToken = await ethers.getContractFactory("MyToken");
    myToken = await MyToken.deploy(10000);
    await myToken.waitForDeployment();
  
    console.log("myToken: " + await myToken.getAddress());
}

async function deployMyTokenMarket() {
    let MyTokenMarket = await ethers.getContractFactory("MyTokenMarket");
    myTokenMarket = await MyTokenMarket.deploy(uniwapRouter, await myToken.getAddress(), await sushi.getAddress(), await masterChef.getAddress());
    await myTokenMarket.waitForDeployment();
  
    console.log("myTokenMarket: " + await myTokenMarket.getAddress());
}


async function main() {
    let [owner, second] = await ethers.getSigners();
    console.log("owner: ", owner.address);
    await deploySushi();
    await deployMasterChef();
    let tx = await sushi.transferOwnership(await masterChef.getAddress());
    await tx.wait();

    await deployMyToken();
    await deployMyTokenMarket();

    await masterChef.add(100, await myToken.getAddress(), true);


    await myToken.approve(await myTokenMarket.getAddress(), 100000);
    await myTokenMarket.addLiquidity(100000, {value: 100000});

    let myTokenBalance = await myToken.balanceOf(owner.address);
    console.log("owner myTokenBalance ", myTokenBalance);

    await myTokenMarket.buyToken({value: 10000});

    myTokenBalance = await myToken.balanceOf(await masterChef.getAddress());
    console.log("masterChef myTokenBalance ", myTokenBalance);

    await delay.advanceBlock(ethers.provider);
    await delay.advanceBlock(ethers.provider);
    await delay.advanceBlock(ethers.provider);
    await delay.advanceBlock(ethers.provider);
    console.log("delay advanceBlock ");

    let pendingSushiAmount = await masterChef.pendingSushi(0, myTokenMarket.getAddress());
    console.log("myTokenMarket pendingSushi ", pendingSushiAmount);

    await myTokenMarket.withdraw();

    myTokenBalance = await myToken.balanceOf(owner.address);
    console.log("owner myTokenBalance ", myTokenBalance);
    let sushiBalance = await sushi.balanceOf(owner.address);
    console.log("owner sushiBalance ", sushiBalance);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });