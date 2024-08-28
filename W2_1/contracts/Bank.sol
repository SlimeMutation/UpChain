// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Bank {
    mapping(address => uint256) public accountBalanceOf;
    mapping(address => uint256) public accountIndexOf;
    address[] public accounts;
    address payable public owner;

    event Withdrawal(address account, uint amount);

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You aren't the owner");
        _;
    }

    function withdraw() public onlyOwner {
        uint256 totalBalance = address(this).balance;
        require(totalBalance > 0, "No balance to withdraw");
        for (uint256 i = 0; i < accounts.length; i++) {
            accountBalanceOf[accounts[i]] = 0;
        }
        owner.transfer(totalBalance);
        emit Withdrawal(msg.sender, totalBalance);
    }

    receive() external payable {
        if (accountIndexOf[msg.sender] == 0) {
            accounts.push(msg.sender);
            accountIndexOf[msg.sender] = accounts.length;
        }
        accountBalanceOf[msg.sender] += msg.value;
    }
}
