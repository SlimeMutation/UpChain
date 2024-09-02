// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract MyTokenV2 is Initializable, ERC20Upgradeable {
    using Address for address;

    function initialize(string memory name, string memory symbol, uint256 initialSupply) public initializer {
        __ERC20_init(name, symbol);
        _mint(msg.sender, initialSupply);
    }

    function transferWithCallback(address recipient, uint256 amount) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        // if (recipient.isContract()) {
        //     bool rv = TokenRecipient(recipient).tokensReceived(msg.sender, amount);
        //     require(rv, "No tokensReceived");
        // }
        return true;
    }


}