// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract Enum {
    enum Status{
        None, //index:0
        Pending,
        Shipped, //index:2
        Completed,
        Rejected,
        Canceled
    }
    Status public status;
    
    struct Order{
        address buyer;
        Status status;
    }
    Order[] public orders;

    function get() view external returns(Status){ //This funciton tell us what is index of status
       return status; 
    }
    function set(Status _status) external { //This funciton will set the index of Status when we want to changing
        status = _status;
    } 

    function ship() external { //Status index will set 2 when we start the function
        status = Status.Shipped;
    }

    function reset() external { // Status index will set 0 when we delete status
        delete status;
    }
}