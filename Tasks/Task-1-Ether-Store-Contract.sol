// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;
//@dev https://app.patika.dev/JessFlexx , https://github.com/TallTalha

//Hands on Task - 1 (Beginner Level): Build and Deploy an Ether-Store Smart Contract with Remix IDE

//In this smart contract, only the contract owner can deposit Ether and 
//the contract owner can transfer the Ether contained in the smart contract to any address.

contract personalVault {
    address public owner;
    uint256 public balance;

    constructor(){
        owner = msg.sender; //The address that runs the contract is the contract owner.
    }

    //We only use smart contract to store ether. So I didn't need the fallback function.
    receive() payable external{
        balance += msg.value;
    }

    function withdraw(address payable _to, uint256 _amount) public returns(bool state){
        require(msg.sender == owner, "You are not authorized to withdraw."); //Contract owner checked.
        require(balance >= _amount,"Insufficient balance."); //The withdrawal amount cannot exceed the balance.
        require(_amount>0,"Withdraw amount cannot be zero."); //I blocked zero unit transaction to avoid system vulnerabilities.

        state = _to.send(_amount);  //.send() returns bool variable.
        //.transfer() returns revert. Since we wrote require, there is no need for revert.
        balance -= _amount; //The amount withdrawn reduced from the vault balance.
    }

}
