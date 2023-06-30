// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Charity {
    address public owner;
    uint public threshold = 10 ether;
    uint public balance = 0;

    struct Donatee {
        address donateeAddress;
        uint last4digitDonatee;
        string fullName;
    }

    struct Donator {
        address donatorAddress;
        uint last4digitDonator;
    }
    
    mapping(address => bool) public isDonor;
    mapping(address => bool) public isAlerted;
    mapping(address => bool) public isThisAddressRegistered;
    mapping(uint => Donatee) private donatees;
    mapping(uint => Donator) private donators;
    address[] private walletAddressDonatee;

    event LogTransaction(address indexed sender, address indexed recipient, uint amount);
    event Alert(address indexed account, uint amount, string alertType);

    modifier onlyOwner() {
        require(0xFD0153e404343462A05D38989BAae635a9194078 == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
        balance = 0;
    }

    function setThreshold(uint newThreshold) public onlyOwner {
        threshold = newThreshold;
    }

    function registerAsDonatee(address _donateeAddress, uint _last4digitDonatee, string memory _fullName) public {
        require(!isThisAddressRegistered[_donateeAddress], "You have been registered");

        isThisAddressRegistered[msg.sender] = true;
        donatees[_last4digitDonatee] = Donatee(_donateeAddress, _last4digitDonatee, _fullName);
        walletAddressDonatee.push(_donateeAddress);
        /**donatees.push(Donatee({
            donateeAddress: msg.sender,
            donateeName: donateeName
        }));*/
    }

    function registerAsDonor(address _donatorAddress, uint _last4digitDonator) public {
        require(!isThisAddressRegistered[_donatorAddress], "You have been registered");

        isThisAddressRegistered[msg.sender] = true;
        donators[_last4digitDonator] = Donator(_donatorAddress, _last4digitDonator);
        walletAddressDonatee.push(_donatorAddress);
        /**donatees.push(Donatee({
            donateeAddress: msg.sender,
            donateeName: donateeName
        }));*/
    }

    function donate(uint amount) public payable {
        require(amount > 0, "Donation amount must be greater than zero.");
        //require(msg.value == amount, "Please send the exact donation amount.");

        balance += amount;
        isDonor[msg.sender] = true;

        if (amount > threshold) {
            emit Alert(msg.sender, amount, "HugeTransaction");
        }

        if (balance > 50 ether) {
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

        if (balance > 50 ether) {
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

    //fx to list all need donate
    function list() public view returns (address[] memory) {
        //return the array of the wallet address
        return walletAddressDonatee;
    }
}
