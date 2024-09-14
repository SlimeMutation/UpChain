// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeflationToken is ERC20{

    uint256 public constant ONE = 10 ** 18;
    uint256 public factor = ONE;
    uint256 public constant REBASE_INTERVAL = 60;
    uint256 public lastRebase;

    constructor(uint256 initialSupply) ERC20("DeflationToken", "DTK") {
        _mint(msg.sender, initialSupply * ONE);
        lastRebase = block.timestamp;
    }

    function totalSupply() public view override returns (uint256) {
        return super.totalSupply() * factor / ONE;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return super.balanceOf(account) * factor / ONE;
    }

    function _transfer(address from, address to, uint256 value) internal override virtual{
        super._transfer(from, to, value * ONE / factor);
    }

    function rebase() public {
        require(block.timestamp - lastRebase >= REBASE_INTERVAL, "Rebase interval not reached");
        factor = factor * 99 / 100;
        lastRebase = block.timestamp;
    }

    
    
}
