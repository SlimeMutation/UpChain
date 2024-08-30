// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Vault {
    using SafeERC20 for IERC20;

    IERC20 public erc20;
    mapping(address => uint256) public accountBalanceOf;


    constructor(IERC20 _erc20) {
        erc20 = _erc20;
    }

    function deposit(uint256 _amount) public {
        require(_amount > 0, 'Vault: deposit amount must be greater than 0');
        accountBalanceOf[msg.sender] += _amount;
        erc20.safeTransferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _amount) public {
        require(_amount > 0, 'Vault: withdraw amount must be greater than 0');
        require(_amount <= accountBalanceOf[msg.sender], 'Vault: withdraw amount must be <= account balance');
        accountBalanceOf[msg.sender] -= _amount;
        erc20.safeTransfer(msg.sender, _amount);
    }


}