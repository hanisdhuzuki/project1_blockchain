import Web3 from 'web3';
// Set the provider with Infura API Key
const network = "sepolia";
let provider = ethers.getDefaultProvider(network, {
  infura: "", // Infura API KEY ---- keep it secret
});
const Web3 = require('web3');
// Connect to the local Ethereum node
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));
const contractABI = require('project_abi.json');

// Set the contract object with the provider
contract = new web3.ethers.Contract(contractAddress, contractABI);
// Set threshold Button Handler
const setThreshold = document.getElementById('setThreshold');
setThreshold.addEventListener('submit', async (event) => {
    event.preventDefault();

    const validationThreshold = document.getElementById('validationThreshold');

    contract.methods.setThreshold(validationThreshold).send();
});

// Donatee regist Button Handler
const donateeRegistration = document.getElementById('donateeRegistration');
donateeRegistration.addEventListener('submit', async (event) => {
    event.preventDefault();

    const addressToRegister = document.getElementById('addressToRegister');
    const numberToRegister = document.getElementById('numberToRegister');
    const fullNameToRegister = document.getElementById('fullNameToRegister');

    if (web3.utils.isAddress(addressToRegister) == true) {
      // Call the smart contract function to store the multiple data entries
      contract.methods.registerAsDonatee(addressToRegister, numberToRegister, fullNameToRegister).send();

      window.alert('Data stored successfully!');
      addressToRegister= ''; // Clear the input fields
      numberToRegister= '';
    } else {
      console.error('Failed to store data:', error);
      alert('Failed to store data. Please try again.');
    }
});

// Donator regist Button Handler
const donatorRegistration = document.getElementById('donatorRegistration');
donatorRegistration.addEventListener('submit', async (event) => {
    event.preventDefault();

    const addressToRegister = document.getElementById('addressToRegister');
    const numberToRegister = document.getElementById('numberToRegister');

    if (web3.utils.isAddress(addressToRegister) == true) {
      // Call the smart contract function to store the multiple data entries
      contract.methods.registerAsDonor(addressToRegister, numberToRegister).send();

      window.alert('Data stored successfully!');
      addressToRegister= ''; // Clear the input fields
      numberToRegister= '';
    } else {
      console.error('Failed to store data:', error);
      alert('Failed to store data. Please try again.');
    }

});

// the donate function in the smart contract
function donate(amount, addressDonator) {
  try {
    const result = contract.methods.donate(web3.utils.toWei(amount, 'ether'), addressDonator).send({
      from: addressDonator,
      value: amount,
    });
    window.alert('Donation successful:', result);
  } catch (error) {
    console.error('Failed to make a donation:', error);
  }
}

// the withdraw function in the smart contract
function withdraw(amount, addressDonatee) {
  try {
    contract.methods.withdraw(web3.utils.toWei(amount, 'ether')).send({
      from: '0x5601b6b8799023e6c5A7753D2D6Eb883089e6Ab9', // The address of the owner/charitable organization
    });;

    window.alert('Withdrawal successful:', result);
  } catch (eror) {
    console.error('Failed to withdraw funds:', error);
  }
}

// Function to get the current balance
function getBalance() {
  let balance = contract.methods.getBalance();
  return balance;
  document.getElementById('balanceOfFunds').innerHTML = balance;
}

// Fetch and display the list of donatees
function displayInfo() {
  const fullNameDonatees = document.getElementById('fullNameDonatees');
  const dispInfo = contract.methods.list();
  dispInfo.forEach(fullNameDonatee => {
      fullNameDonatees.innerHTML += `<p>${fullNameDonatee}</p>`;
  });
}

//call Function
//donate Call
const donateFund = document.getElementById('donateFund');
donateFund.addEventListener('submit', async (event) => {
    event.preventDefault();

    const donationAmount = document.getElementById('donationAmount');
    const addressDonor = document.getElementById('addressDonor');

    donate(donationAmount, addressDonor);
});

//withdraw Call
const withdrawFund = document.getElementById('withdrawFund');
withdrawFund.addEventListener('submit', async (event) => {
    event.preventDefault();

    const withdrawalAmount = document.getElementById('donationAmount');
    const addressDonatee = document.getElementById('addressDonor');

    withdraw(withdrawalAmount, addressDonatee);
});
