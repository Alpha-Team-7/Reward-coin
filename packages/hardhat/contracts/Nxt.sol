//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

///@author Bg-Alpha-project Team
///@title Nestcoing batch transfer contract
///@notice Only the admin has access to use this contract to make batch transfers to loyal Nestcoin customers
///@dev Contract under development to enable batch transfer of nest coin tokens to loyal customers

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Nestcoin.sol";

contract Nxt is Ownable {
    Nestcoin public nestcoin;

    mapping(address => bool) private admins;

    event Payment(
        address indexed payer,
        uint256 amount,
        bytes32 indexed ref,
        uint256 time
    );
    event BatchTransfer(address indexed adminAddress, uint256 amount);

    constructor(address tokenAddr) {
        nestcoin = Nestcoin(tokenAddr);
    }

    ///@notice batch tranfer function using three arguments, array addresses of customers and amount of tokens to be sent, total amount of tokens sent.
    function batchTokenTransfer(
        address[] memory _userAddr,
        uint256[] memory _amount,
        uint256 totalAmount
    ) public onlyAdmin {
        require(
            _userAddr.length == _amount.length,
            "Number of Addresses must match amount"
        );
        require(_userAddr.length <= 200, "Array must not be greater than 200");

        nestcoin.mint(
            address(this),
            totalAmount - nestcoin.balanceOf(address(this))
        );
        for (uint256 i = 0; i < _userAddr.length; i++) {
            nestcoin.transfer(_userAddr[i], _amount[i]);
        }

        emit BatchTransfer(msg.sender, totalAmount);
    }

    ///@notice with a ref, every payment is traceable to the value provided
    function pay(uint256 amountOfTokens, bytes32 ref) public {
        ///@dev Transfer token
        nestcoin.transferFrom(msg.sender, address(this), amountOfTokens);

        ///@dev Emit Pay event
        emit Payment(msg.sender, amountOfTokens, ref, block.timestamp);
    }

    ///@notice function to add admin by owner of contract
    function addAdmin(address admin) public onlyOwner {
        admins[admin] = true;
    }

    ///@notice function to remove admin by owner of contract
    function removeAdmin(address admin) public onlyOwner {
        admins[admin] = false;
    }

    ///@notice function to check whether Nestcoin representative is admin
    function isAdmin(address user) public view returns (bool) {
        return admins[user];
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Not admin");
        _;
    }
}
