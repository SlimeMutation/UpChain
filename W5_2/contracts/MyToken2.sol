// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20Permit{

    constructor(uint256 initialSupply) ERC20(unicode"我的测试Token", "MTK") ERC20Permit("MTK"){
        _mint(msg.sender, initialSupply * 10 ** 18);
    }
    
}
