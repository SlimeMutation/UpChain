const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Bank", function () {

    let bank;
    let owner;
    let addr1;
    let addr2;
    async function setupContractAndAccounts () {
        let accounts = await ethers.getSigners()
        owner = accounts[0]
        addr1 = accounts[1]
        addr2 = accounts[2]
    
        const Bank = await ethers.getContractFactory("Bank");
        bank = await Bank.deploy();
        await bank.waitForDeployment();
        console.log("bank:" + bank.getAddress());
    }

    before(async function () {
        await setupContractAndAccounts();
    });

    it("Should set the right owner", async function () {
        expect(await bank.owner()).to.equal(owner.address);
    });

    it("Should accept deposits and update account balances", async function () {
        // addr1 向合约存入 1 ether
        await addr1.call({
          to: bank.address,
          value: ethers.parseEther("1.0")
        });
    
        expect(await bank.accountBalanceOf(addr1.address)).to.equal(ethers.parseEther("1.0"));
    
        // addr2 向合约存入 2 ether
        await addr2.call({
          to: bank.address,
          value: ethers.parseEther("2.0")
        });
    
        expect(await bank.accountBalanceOf(addr2.address)).to.equal(ethers.parseEther("2.0"));
    });

    it("Should allow the owner to withdraw all funds", async function () {
        // addr1 向合约存入 1 ether
        await addr1.call({
          to: bank.address,
          value: ethers.parseEther("1.0")
        });
    
        // addr2 向合约存入 2 ether
        await addr2.call({
          to: bank.address,
          value: ethers.parseEther("2.0")
        });
    
        // 提取资金前获取合约余额
        const contractBalanceBefore = await ethers.provider.getBalance(bank.address);
    
        // 提取资金前获取owner余额
        const ownerBalanceBefore = await ethers.provider.getBalance(owner.address);
    
        // 以owner身份提取资金
        const tx = await bank.withdraw();
    
        // 获取交易相关信息
        const receipt = await tx.wait();
        const gasUsed = receipt.gasUsed.mul(receipt.effectiveGasPrice);
    
        // 提取资金后获取合约余额
        const contractBalanceAfter = await ethers.provider.getBalance(bank.address);
        expect(contractBalanceAfter).to.equal(0);
    
        // 提取资金后获取owner余额
        const ownerBalanceAfter = await ethers.provider.getBalance(owner.address);
        expect(ownerBalanceAfter).to.equal(ownerBalanceBefore.add(contractBalanceBefore).sub(gasUsed));
    });

    it("Should revert if non-owner tries to withdraw funds", async function () {
        // addr1 向合约存入 1 ether
        await addr1.call({
          to: bank.address,
          value: ethers.parseEther("1.0")
        });
    
        // addr2 试图提取资金
        await expect(bank.connect(addr2).withdraw()).to.be.revertedWith("You aren't the owner");
    });

});