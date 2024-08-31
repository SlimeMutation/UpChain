// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MyERC721Market {
    using SafeERC20 for IERC20;

    ERC721URIStorage public erc721;
    IERC20 public erc20;
    mapping(uint256 => uint256) public tokenPrice;
    mapping(uint256 => address) public tokenOwner;

    constructor(ERC721URIStorage _erc721, IERC20 _erc20) {
        erc721 = _erc721;
        erc20 = _erc20;
    }

    function list(uint256 _tokenId, uint256 _price) public {
        require(erc721.ownerOf(_tokenId) == msg.sender, "not NFT owner");
        tokenPrice[_tokenId] = _price;
        tokenOwner[_tokenId] = msg.sender;
    }

    function buyNFT(uint256 _tokenId) public {
        uint256 nftPrice = tokenPrice[_tokenId];
        address nftOwner = tokenOwner[_tokenId];
        require(nftPrice > 0 && nftOwner != address(0), "NFT not list");
        require(erc20.balanceOf(msg.sender) >= nftPrice, "insufficient balance");
        erc20.safeTransferFrom(msg.sender, nftOwner, nftPrice);
        erc721.safeTransferFrom(nftOwner, msg.sender, _tokenId);
        tokenPrice[_tokenId] = 0;
        tokenOwner[_tokenId] = address(0);
    }
}