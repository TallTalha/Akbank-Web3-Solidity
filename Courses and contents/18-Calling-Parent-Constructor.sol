// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//ITU Blockchain Inheritance videosunda aynı içerik toplu olarak işlendi.

// Base contract X
contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

// Base contract Y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// There are 2 ways to initialize parent contract with parameters.

// Statik olarak değer verebiliriz
contract B is X("Input to X"), Y("Input to Y") {

}
//Veya bu şekilde dinamik olarak değer almalarını sağlayabiliriz.
contract C is X, Y {
    
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

// Parent constructors are always called in the order of inheritance
// regardless of the order of parent contracts listed in the
// constructor of the child contract.

//Aşağıdaki örnekten çıkaracağımız ders şudur: Önce parentların sonra child'ın constructor'ı initialize edilir.
//Parentlar arasındaki init sırası ise "is"'den sonra önce hangi parent yazıldıysa önce o parent initialize edilir sonrasında diğer parent init edilir.

// Order of constructors called:
// 1. X
// 2. Y
// 3. D
contract D is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

// Order of constructors called:
// 1. X
// 2. Y
// 3. E
contract E is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}
