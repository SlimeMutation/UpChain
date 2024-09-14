// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyCallOption is ERC20, Ownable{

    using SafeERC20 for IERC20;

    IERC20 public usdc;
    uint128 public price;
    uint96 public exerciseTime;
    uint32 public durationTime;

    constructor(IERC20 _usdc, uint128 _price, uint96 _exerciseTime, uint32 _durationTime) ERC20(unicode"我的测试看多期权Token", "CALLTOKEN") Ownable(msg.sender){
        price = _price;
        exerciseTime = _exerciseTime;
        durationTime = _durationTime;
        usdc = _usdc;
    }

    function issueOption() onlyOwner public payable {
        require(msg.value > 0, "eth value cant be 0");
        _mint(msg.sender, msg.value);
    }

    function settleOption(uint256 _amount) public {
        require(block.timestamp >= exerciseTime && block.timestamp < exerciseTime + durationTime, "not in settle time range");
        require(balanceOf(msg.sender) >= _amount, "amount must > balance");
        _burn(msg.sender, _amount);
        usdc.safeTransferFrom(msg.sender, address(this), _amount * price);
        safeTransferETH(address(msg.sender), _amount);
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
    }

    function destory() public onlyOwner {
        require(block.timestamp >= exerciseTime + durationTime, "not expire yet");
        usdc.safeTransfer(msg.sender, usdc.balanceOf(address(this)));
        selfdestruct(payable(msg.sender));
    }
    
}
