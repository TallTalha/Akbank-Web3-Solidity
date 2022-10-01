// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

//Interfaces (Arayüz):

//Solidity'e özgün bir konsept değil. OOP dillerinde olan bir konsept.
//Polymorphism kopseptinin uygulanma biçimlerinden biridr.

/*
Polimorfizim nedir?
Şöyle bir şeyi savunur;

                    Parent (a)
            ________________|____________
            |             |             |
    child1 (a,c), child2 (a,b), child3 (a,d)
    
    Kapsayıcı class alt class'lar ile konuşmalı. Sınıflar arasında etkileşim için bir standart oluşturur.
    Yani, child class'lar parent class'ın özelliğini taşımalı, mecburi olmamakla, child classların kendinelerine özgü ek özellikleri olabilir. 
    Solidity'de sınıflar -> kontratlardır
*/

/*
Interface'ler (Arayüzler) çalışma mantığı farklı olan ama yaptığı iş aynı olan kontratların (örneğin token kontratları) ortak bir standarda sahip olmasını böylece bu kontratlarla çalışmak isteyen birinin her bir kontrata özgü kod yazmak yerine bu standarda uygun tek bir kod yazmasını sağlar

ERC20, ERC721, ERC1155 gibi standartlar aslında bir interface şeklinde tanımlanmıştır.

You can interact with other contracts by declaring an Interface.

Interfaces:

*Cannot have any functions implemented
*Can inherit from other interfaces
*Declared functions must be external
*Cannot declare state variables
*Cannot declare a constructor

*/

contract EthSender {
    function _send(address payable to, uint256 amount) private {
        to.transfer(amount);
    }

    function sendWithStrategy(address strategyAddress) external {
        (address payable to, uint256 amount) = IStrategy(strategyAddress).getAddressAndAmount();
        _send(to, amount);
    }

    receive() external payable { }
}

abstract contract Strategy {
    // Virtual: Benden sonra gelen bu fonksiyonu değiştirebilir
    function getAddressAndAmount() external virtual view returns(address payable, uint256);
}

interface IStrategy {
    function getAddressAndAmount() external view returns(address payable, uint256);
}

contract AddressStrategy1 {
    uint256 constant ETHER_AMOUNT = 0.1 ether;

    function getAddressAndAmount() external pure returns(address payable, uint256) {
        return(payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2), ETHER_AMOUNT);
    }
}

contract AddressStrategy2 {
    uint256 constant ETHER_AMOUNT = 0.1 ether;

    function getAddressAndAmountV2() external pure returns(address payable, uint256) {
        uint256 amount = ETHER_AMOUNT * 5;
        return(payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2), amount);
    }
}

contract AddressStrategy3 is Strategy {
    uint256 constant ETHER_AMOUNT = 0.1 ether;

    // Override: Benden önce gelen fonksiyonu değiştiriyorum
    function getAddressAndAmount() external pure override returns(address payable, uint256) {
        uint256 amount = ETHER_AMOUNT * 5;
        return(payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2), amount);
    }
}