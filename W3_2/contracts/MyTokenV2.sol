// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

interface TokenRecipient {
    function tokensReceived(address sender, uint amount) external returns (bool);
}

contract MyTokenV2 is ERC20Upgradeable {
    using Address for address;

    function transferWithCallback(address recipient, uint256 amount) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        // if (recipient.isContract()) {
        //     bool rv = TokenRecipient(recipient).tokensReceived(msg.sender, amount);
        //     require(rv, "No tokensReceived");
        // }
        return true;
    }


}