// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20{

    constructor(uint256 initialSupply) ERC20(unicode"我的测试Token", "MTK2") {
        _mint(msg.sender, initialSupply * 10 ** 18);
    }
    
}
