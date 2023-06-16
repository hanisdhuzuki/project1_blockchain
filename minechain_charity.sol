// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Charity {
    address public owner;
    uint public threshold = 10 ether;
    uint public balance = 0;
    mapping(address => bool) public isDonor;
    mapping(address => bool) public isAlerted;

    event LogTransaction(address indexed sender, address indexed recipient, uint amount);
    event Alert(address indexed account, uint amount, string alertType);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
        balance = 0;
    }

    function setThreshold(uint newThreshold) public onlyOwner {
        threshold = newThreshold;
    }

    function donate(uint amount) public payable {
        require(amount > 0, "Donation amount must be greater than zero.");
        require(msg.value == amount, "Please send the exact donation amount.");

        balance += amount;
        isDonor[msg.sender] = true;

        if (amount > threshold) {
            emit Alert(msg.sender, amount, "HugeTransaction");
        }

        if (address(this).balance > 50 ether && !isAlerted[msg.sender]) {
            emit Alert(msg.sender, balance, "MoneyLaundering");
            isAlerted[msg.sender] = true;
        }

        emit LogTransaction(msg.sender, address(0), amount);
    }

    function withdraw(uint amount) public {
        require(amount > 0, "Withdrawal amount must be greater than zero.");
        require(balance >= amount, "Insufficient balance.");

        balance -= amount;
        payable(msg.sender).transfer(amount);
        emit LogTransaction(msg.sender, address(0), amount);

        if (address(this).balance > 50 ether && !isAlerted[msg.sender]) {
            emit Alert(msg.sender, balance, "MoneyLaundering");
            isAlerted[msg.sender] = true;
        }
    }

    function isAboveThreshold() public view returns (bool) {
        return balance > threshold;
    }

    function getBalance() public view returns (uint) {
        return balance;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
