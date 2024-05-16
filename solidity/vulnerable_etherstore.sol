// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherStore {
    address owner;
    mapping(address => bool) public users;
    mapping(address => uint) public balances;

    // Events for monitoring changes on the blockchain
    event UserAdded(address user);
    event Deposit(address indexed user, uint amount);
    event Withdrawal(address indexed user, uint amount);

    constructor() {
        owner = msg.sender;
        users[owner] = true;
    }

    // Function to add a new user, restricted to owner only
    function add_user(address _user) public {
        require(owner == msg.sender, "Only owner can add user");
        users[_user] = true;
        emit UserAdded(_user);
    }

    // Owner-only function to recover all Ether from the contract
    function recover() public {
        require(owner == msg.sender, "Only owner can recover");
        (bool sent, ) = address(msg.sender).call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    // Allow users to deposit Ether
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Secure function for users to withdraw their Ether
    function withdraw() public {
        require(users[msg.sender], "You are not allowed to withdraw");
        uint bal = balances[msg.sender];
        require(bal > 0, "You don't have any balance");

        balances[msg.sender] = 0;  // Update balance before sending Ether
        emit Withdrawal(msg.sender, bal);

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
    }
}