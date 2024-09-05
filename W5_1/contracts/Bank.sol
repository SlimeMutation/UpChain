pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bank{
    mapping(address => uint) public deposited;
    uint256 public totalAmount;
    address public immutable token;
    address public immutable owner;
   

    constructor(address _token) {
        token = _token;
        owner = msg.sender;
    }


    function deposit(address user, uint amount) public {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer from error");
        deposited[user] += amount;
        totalAmount += amount;
    }


    function permitDeposit(address user, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        IERC20Permit(token).permit(msg.sender, address(this), amount, deadline, v, r, s);
        deposit(user, amount);
    }

    function withdrawToOwner() public {
        if (totalAmount > 100) {
            uint256 withdrawAmount = totalAmount/2;
            require(IERC20(token).transfer(owner, withdrawAmount), "Transfer to owner error");
            totalAmount -= withdrawAmount;
        }
    }


}

