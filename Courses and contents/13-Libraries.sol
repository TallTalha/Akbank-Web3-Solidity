// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

library Math {
    function plus(uint x,uint y)public pure returns(uint) {
        return x + y;
    }
    function minus(uint x,uint y)public pure returns(uint) {
        return x - y;
    }
    function multiple(uint x,uint y)public pure returns(uint) {
        return x * y;
    }
    function divide(uint x,uint y)public pure returns(uint) {
        require(y!=0,"Divisor cannot be zero.");
        return x / y;
    }

    function bigger(uint x, uint y)public pure returns(uint){
        if(x>y) return x;
        else return y;
    }
}

library Search{
    function indexOf(uint[] memory list,uint data) public pure returns(uint){
        for(uint i=0;i<list.length;i++){
            if (list[i]==data) return i;
            }
        return list.length; //-1 döndüremeyiz uint
    }
}

contract Library{

    using Math for uint;//Bu nedemek: Uint değerler artık bu kütüphaneyi kullanabilir.
    // Mesela: x.plus(y); şeklinde kullanabiliriz.

    function plusTrial(uint x,uint y)public pure returns(uint){
        return Math.plus(x,y);
    }
    function divideTrial(uint x,uint y)public pure returns(uint){
        return Math.divide(x,y);
    }
    function biggerTrial(uint x,uint y)public pure returns(uint){
        return Math.bigger(x,y);
    }


    
    //Search library kullanımı.
    function search(uint[] memory _arr, uint _data)public  pure returns(uint){
        return Search.indexOf(_arr,_data);
    }
    
    using Search for uint[];
    function search2(uint[] memory _arr, uint _data)public  pure returns(uint){
        return _arr.indexOf(_data);
    }
    
    
}