// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;
//@dev https://app.patika.dev/JessFlexx , https://github.com/TallTalha

///Hands on Task - 2 (Intermediate Level): Build and Deploy a To-Do List

////A to-do list structure will be created in this smart contract. The created structure will be kept in an array. 
//In this array, there will be inserting, updating and reading.

contract TodoList{

    struct Todo{
        string text;
        bool isDone; // is done/true or not/false ?
    }

    Todo[] public todo_arr; //array of struct

    function create(string calldata _text) public{
         todo_arr.push(Todo(_text,false)); //The data to be added to the to-do list is pushing to the array.
    }

    function get(uint _index) invalidIndex(_index) public view returns(string memory _string,bool _state){
        Todo storage todo = todo_arr[_index]; //storage cheaper than memory
        _string = todo.text;
        _state = todo.isDone;
        //default variables are cheaper than returns. "return(todo.text,todo.isDone)"
    }

    function updateText(string calldata _text, uint _index) invalidIndex(_index) public {
        Todo storage todo = todo_arr[_index];
        todo.text = _text; //The text field updated.
        //This coding method saves some gas when accessing only one area.
    }

    function updateIsDone(uint _index) invalidIndex(_index) public {
        Todo storage todo = todo_arr[_index];
         todo.isDone = !todo.isDone; //We got the inverse of the isDone variable with "!".
    }
    
    //Modifier used to avoid code duplication. The modifier is checking valid array range.
    modifier invalidIndex(uint _index){ 
        require(_index < todo_arr.length, "Invalid index."); 
        _;
    }


}