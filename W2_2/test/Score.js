// 文件名：test/Score.js

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Score Contract", function () {
  let scoreContract;
  let teacherContract;
  let teacherContractAddress;
  let teacher;
  let student;
  let owner;

  beforeEach(async function () {
    // 部署合约前获取signers
    [owner, teacher, student] = await ethers.getSigners();

    // 部署Teacher合约
    const Teacher = await ethers.getContractFactory("Teacher");
    teacherContract = await Teacher.deploy();
    await teacherContract.waitForDeployment();
    teacherContractAddress = teacherContract.getAddress();

    // 部署Score合约
    const Score = await ethers.getContractFactory("Score");
    scoreContract = await Score.deploy(teacherContractAddress);
    await scoreContract.waitForDeployment();

    

    // 将Score合约地址设置在Teacher合约中
    await teacherContract.setScoreAddress(scoreContract.getAddress());
  });

  it("Should set the correct teacher address", async function () {
    expect(await scoreContract.teacher()).to.equal(teacherContract.getAddress());
  });

  it("Should allow teacher to modify the score", async function () {
    // 只有教师可以修改分数
    await expect(
      scoreContract.connect(teacher).modifyScore(student.address, 85)
    ).to.be.revertedWith("You are not the teacher");
  });

  it("Should not allow non-teacher to modify the score", async function () {
    // 非教师账户尝试修改分数，应该失败
    await expect(
      scoreContract.connect(student).modifyScore(student.address, 85)
    ).to.be.revertedWith("You are not the teacher");
  });

  it("Should revert if score is greater than 100", async function () {
    // 教师尝试设置大于100的分数，应该失败
    await expect(
      teacherContract.connect(teacher).modifyScore(student.address, 110)
    ).to.be.revertedWith("score > 100");
  });

  it("Teacher contract should be able to modify score via Score contract", async function () {
    // 通过Teacher合约修改Score合约中的分数
    await teacherContract.connect(teacher).modifyScore(student.address, 90);
    expect(await scoreContract.scores(student.address)).to.equal(90);
  });
});
