// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract Counter{
    uint private counter;
    
    function getCount() view public returns(uint) {
        return counter;
    }
    function incCount() public {  //increase ve decrease işlemleri state variable'ı değiştridği için
        counter += 1;              //blockchain'de değişiklik yapmış olur. Bu yüzden gas fee bedeli alınır.
    } 
    function decCount() public {
        counter -= 1;
    }
}