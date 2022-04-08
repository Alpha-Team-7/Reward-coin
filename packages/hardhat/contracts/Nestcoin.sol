//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

///@author Bg-Alpha-project Team
///@title Nestcoin minting contract

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Nestcoin is ERC20, Ownable {
    constructor() ERC20("Nestcoin", "NTK") {}

    ///@dev mints amount of tokens to set addresses, only called by owner of contract
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
