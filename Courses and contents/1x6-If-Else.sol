// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract IfElse{

    bytes32 private hashedPass;
    uint256 private loginCount;
    
    constructor(string memory pass){
        hashedPass = keccak256(abi.encode(pass));
    }

    function getCount() view public returns(uint256){
        return loginCount;
    }

    function loginValid(string memory pass) public returns (bool){
        if( hashedPass == keccak256(abi.encode(pass)) ){
            loginCount++;//loginCount+=1;
            return true;
        }
        else {
            return false;
        }
        // return hashedPass == keccak256(abi.encode(pass)); bu daha kısa ve verimli olan kodumuz
    }
    //if-else'i göstermek için tek satırlık kod yerine yukarıdaki uzun kodu kullandık.

    function loginValidNumber (string memory pass) public view returns(uint8){
        if( hashedPass == keccak256(abi.encode(pass)) ){
            return 1;
        }
        else {
            return 0;
        }
        // return hashedPass == keccak256(abi.encode(pass)) ? 1 : 0 ; daha kısa ve verimli yazımı 
    }

    function loginStatus() public view returns(uint8){
        if(loginCount == 0){
            return 0;
        }
        else if(loginCount>0 && loginCount!=1){
            
            return 2;
        }
        else if(loginCount == 1){
            return 1;
        }
        else{
            return 3;
        }
    }

}
