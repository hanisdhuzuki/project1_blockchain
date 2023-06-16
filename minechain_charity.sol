// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Charity {
    // Define the owner of this contract
    address public owner;
    // Define the threshold value for transactions
    uint public threshold = 10 ether;
    // Define the current balance of the contract
    uint public balance = 0;
    // Define an event to log all transactions
    event LogTransaction(address indexed sender, address indexed recipient, uint amount);
    // Modifier to check if the sender is the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    // Constructor that sets the initial owner of the contract
    constructor() {
        owner = msg.sender;
        balance = 0;
    }
    // Function to set the threshold value
    function setThreshold(uint newThreshold) public onlyOwner {
        threshold = newThreshold;
    }
    // Function to donate funds into the contract
    function donate(uint amount) public payable {
        require(amount > 0);
        balance += amount;
        emit LogTransaction(msg.sender, address(0), amount);
    }
    // Function to withdraw funds from the contract
    function withdraw(uint amount) public {
        require(amount > 0);
        require(balance >= amount);
        balance -= amount;
        payable(msg.sender).transfer(amount);
        emit LogTransaction(msg.sender, address(0), amount);
    }
    // Function to check if the contract balance is above the threshold
    function isAboveThreshold() public view returns (bool) {
        return balance > threshold;
    }
    // Function to get the current balance of the contract
    function getBalance() public view returns (uint) {
        return balance;
    }
    // Function to get the owner of the contract
    function getOwner() public view returns (address) {
        return owner;
    }
}
