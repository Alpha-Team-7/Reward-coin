//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";
import "./Nestcoin.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Nxt {
    NestCoin public nestcoin;

    constructor(address tokenAddr) {
        nestcoin = NestCoin(tokenAddr);
    }


    function batchTokenTransfer(address owner, address[] memory _userAddr,  uint256[] memory _amount) public  {
        require(_userAddr.length == _amount.length, "Number of Addresses must match amount");
        for (uint256 i = 0; i < _userAddr.length; i++) {
            transferFrom(owner, _userAddr[i], _amount[i]);
        }

    }

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _burn(uint256 tokenId)
        internal override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
}

