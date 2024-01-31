pragma solidity 0.8.0;

contract EtherStore {
    address owner;
    mapping(address => bool) public users;
    mapping(address => uint) public balances;

    constructor(){
        owner = msg.sender;
        users[owner] = true;
    }

    function add_user(address _user) public {
        require(owner == msg.sender, "Only owner can add user");
        users[_user] = true;
    }

    function recover() public {
        require(owner == msg.sender, "Only owner can recover");
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(users[msg.sender], "You are not allowed to withdraw");

        uint bal = balances[msg.sender];
        require(bal > 0, "You don't have any balance");

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }
}