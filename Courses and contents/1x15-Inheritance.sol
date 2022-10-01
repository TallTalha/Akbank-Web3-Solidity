// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

// virtual: Virtual ile nitelenmiş bir Super contrara ait fonksiyon artık Sub contrat'lar tarafından override edilebilir anlamıne gelir.

contract A {
    uint public x;

    uint public y;

    function setX(uint _x) virtual public { //Virtual ile nitelenmiş setX fonksiyonu, sub kontart olan B kontrında override edilebilir.
        x = _x;     //B kontratındaki setX'e bakılırsa override ile nitelendiğini göreceksin bu setX fonksiyonunun değiştiirldiğini ifade eder.
    }

    function setY(uint _y) virtual public {
        y = _y;
    }
}
// override : Super class'tan inheritance yaptığımız/miras aldığımız fonskiyonları değiştirebiliriz. 
//Bu değişikliği gerçekleştirirken, değiştirdiğimiz fonksiyonu "override" ile nitelendirmemiz gereklidir.

contract B is A {

    uint public z;

    function setZ(uint _z) public {
        z = _z;
    }

    function setX(uint _x) override public { //Override ile bildirim yaptıktan sonra setX'i değiştirebiliriz.
        x = _x + 2;
    }

}

//--------------------------------------------------------------

contract Human {
    function sayHello() public pure virtual returns(string memory) {
        return "itublockchain.com adresi uzerinden kulube uye olabilirsiniz :)";
    }
}

//SuperHuman sub contract , human ise super contrat oldu. Humandan alınan sayhello'yu override ettik.
contract SuperHuman is Human {
    function sayHello() public pure override returns(string memory) {
        return "Selamlar itu blockchain uyesi, nasilsin ? :)";
    }

    function welcomeMsg(bool isMember) public pure returns(string memory) {
        return isMember ? sayHello() : super.sayHello(); //Human.sayHello(); şeklinde de yazabiliridk. 
    }
}

// import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

//import ile github'dan contract inheritance yapabiliriz. 
//Yada o linkten kodu kopyalayıp, kendi dosyalarımıza ekleyerek, miras almayı yine uygulayabilirdik..

contract Wallet is Ownable {
    //Ownable bizim super contract'ımız oldu oradaki public fonskiyonları, değişkenleri, modifierları, eventleri kendi kontratımızda kullanabiliriz.
    fallback() payable external {}

    function sendEther(address payable to, uint amount) onlyOwner public { //onlyOwner bir modifier ve bunu link ile import ettiğimiz, 
        to.transfer(amount);                                               //Ownable.sol dosyasındaki Ownable contract'ından miras aldık.
    }

    function showBalance() public view returns(uint) {
        return address(this).balance;
    }
}