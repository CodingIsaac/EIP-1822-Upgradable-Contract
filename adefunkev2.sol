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

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner is allowed to perform this action"
        );
        _;
    }

    function initialize() public {
        require(!initialized, "Contract already Initialized");
        initialized = true;
        TotalSupply = 500000 * (10**18);
        Name = "Morenikeji";
        Symbol = "MKJ";
        mint(0xAA5AC6134633183C81436499fb38748D128e039b);
        owner = msg.sender;
    }

    function ConstructData() public pure returns (bytes memory data) {
        data = abi.encodeWithSignature("initialize()");
    }

    function mint(address _admin) internal {
        balance[_admin] += TotalSupply;
    }

    function balanceOf(address _addr) public view returns (uint256) {
        return balance[_addr];
    }

    function transfer(address _address, uint256 _amount) public {
        require(balance[msg.sender] >= _amount, "Insufficient Fund");
        balance[msg.sender] -= _amount;
        balance[_address] += _amount;
    }

    function approve(address _to, uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Unable to approve");
        Approve[msg.sender][_to] = _amount;
    }

    function TransferFrom(
        address from,
        address to,
        uint256 amount
    ) public {
        uint256 Updatedbalance = Approve[from][to];
        require(Updatedbalance >= amount, "Amount unapproved");
        Approve[from][to] -= amount;
        balance[from] -= amount;
        balance[to] += amount;
    }

    function allowance(address _addr) public view returns (uint256) {
        return (Approve[msg.sender][_addr]);
    }

    function burn(address _addr, uint _amount) public {
       balance[_addr] -= _amount;

    }

    function upgradeable(address _newAddress) public {
        require(msg.sender == owner, "You are not allowed to upgrade");
        updateCodeAddress(_newAddress);
    }
}
