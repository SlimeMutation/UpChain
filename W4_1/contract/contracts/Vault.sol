// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Vault {
    using SafeERC20 for IERC20;

    address public immutable erc20Address;
    mapping(address => uint256) public accountBalanceOf;


    constructor(address _erc20) {
        erc20Address = _erc20;
    }

    function permitDeposit(uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        IERC20Permit(erc20Address).permit(msg.sender, address(this), amount, deadline, v, r, s);
        deposit(amount);
    }

    function deposit(uint256 _amount) public {
        require(_amount > 0, 'Vault: deposit amount must be greater than 0');
        accountBalanceOf[msg.sender] += _amount;
        IERC20(erc20Address).safeTransferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _amount) public {
        require(_amount > 0, 'Vault: withdraw amount must be greater than 0');
        require(_amount <= accountBalanceOf[msg.sender], 'Vault: withdraw amount must be <= account balance');
        accountBalanceOf[msg.sender] -= _amount;
        IERC20(erc20Address).safeTransfer(msg.sender, _amount);
    }


}