// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./proxiable.sol";

contract Funke is Proxiable {

    uint256 TotalSupply;
    string Name;
    string Symbol;
    bool public initialized;
    address public owner;

    mapping(address => uint256) balance;

    mapping(address => mapping(address => uint256)) Approve;

    function initialize() public {
        require(!initialized, "Contract already Initialized");
        initialized = true;
        TotalSupply = 500000 * (10**18);
        Name = "Morenikeji";
        Symbol = "MKJ";
        mint(0xAA5AC6134633183C81436499fb38748D128e039b);
        owner = msg.sender;


    }

function ConstructData() public pure returns(bytes memory data) {
    data = abi.encodeWithSignature("initialize()");

}

function mint(address _admin) internal {
    balance[_admin] += TotalSupply;
}

function balanceOf(address _addr) public view returns(uint256) {
    return balance[_addr];
}

function transfer(address _address, uint256 _amount) public {
    require(balance[msg.sender] >= _amount, "Insufficient Fund");
    balance[msg.sender] -= _amount;
    balance[_address] += _amount;
}

function approve(address _to, uint256 _amount) public {
    require(balanceOf(msg.sender) >= _amount, "Unable to approve" );
    Approve[msg.sender][_to] = _amount;
}




}