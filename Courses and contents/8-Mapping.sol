// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract Mapping{
    // bool public resgister;
    
    // function isRegistered(){
    //     if(resgister==true) /* login(); */ ;
    //     else /* goRegister(); */ ;
    // }
    //Mapping olmadan buna benzer bir kod yazardık.

    //Bazı notlar;
    //Mapping temel kütüphanede listeleme yapamaz. Ek kütüphaneler ekleyerek mapping listelenebilir. 
    //Mapping kullanırken arkada hashing foksiyonu çalışır.
    //Mapping gaz tasarrufu sağlar. Verilere kolayca erişip düzenleyebilme avantajına sahibiz.
    //Mapping array gibi ardışık sıralanmaz. Hashlenir ve indexi  belirlenir. Listeleme yapmak için ek kütüphane gerekir.
    //Mapping tanımlandığında değerler default değerlerini alır, mesela atama yapılmadan değişkenler okunursa: uint=0'dır, address=0x....0'dır vb.
    
    
    //Mapping örenği:
//require(); içindeki koşul true değilse revert ediyor ve içinde bulunduğu fonskiyonun çağrılmasını engelliyor.Ek olarak uyarı mesajı yazmamızı sağlıyor.
    mapping (address=>bool) public resgistered;
    mapping (address=>uint256) public favNums;

    function resgister(uint256 _favNum)public{
        require(!resgistered[msg.sender], "Kayitli kullanici adresi girdiniz."); //registered adress default olarak false değeri alır. eğer kayıt fonksiyonu ile
        resgistered[msg.sender] = true; //önceden kayıt yapıldıysa kondisyon false olur ve uyarı mesajı alırız.
        favNums[msg.sender] = _favNum;  //Eğer resgistered register olmadıysa default olarak false olduğu için kondisyon true çıkar ve kayıt yapılır.
    }
    
    function deleteRegistered() public {
        require(resgistered[msg.sender], "Bu adrese sahip kayitli kullanici yok."); //default değer false olduğu için kondisyon sağlanır, uyarı alırız.
        delete(resgistered[msg.sender]);
        delete (favNums[msg.sender]);
    }
    //msg.sender gibi golabal değişkenler işin içine girdiği için anlamakta bir tık sıkıntı yaşayabiliyoruz.
    //Ne yazdığını anlaman gerek: Kontrat yazıyorsun ve o kontratı kullanacak addressler'var, adres bilgisi kontrat çalıştığında otomatik verilmiş olacağı için 
    //bu bilgiye önceden sahip olduğunu varsayarak yazman gerekir. 
    //Yani OOP'deki gibi kullanıcının veri girebilmesi için belirlenek input sistemini düşünmene gerek yok.
    //msg.sender ile input geliyor zaten, hali hazırda input sistemin var.
    //Ardışık sırlama yok ama adresleri bir adres arryin'de tutarak sıralayabiliriz.
    //Ayrıca adresleri kayıt ettiğimiz için arrayden index verip mapping ile karşılığa bakabiliriz.
    //Aşğıda örenği var.

mapping ( address => uint ) public balances ;
mapping ( address => bool ) public inserted ;
address [ ] public keys ;
function set ( address _key , uint _val ) external {
   balances [ _key ] = _val ;

    if ( ! inserted [ _key ] ) {
        inserted [ _key ] 
        keys.push ( _key ) ;} //Burada adresler bir array'e push edilir.
}
function getSize ( ) external view returns ( uint ) {
    return keys.length ;
}
function first ( ) external view returns ( uint ) {
    return balances [ keys [ 0 ] ] ;
}
function last ( ) external view returns ( uint ) {
    return balances [ keys [ keys . length - 1 ] ] ;

}
function get ( uint i ) external view returns ( uint ) {
    return balances [ keys [ _i ] ] ; //Burada array indexi ile mapping'i kullandık.
}


//deploy etmeden önce contract'ı NestedMapping seçerek bir .sol dosyasında farklı kontratlar çalıştırabilirsin.
contract NestedMapping { //Borç verisi tutan bir mapping yapacaz. 3 değer var. Borcu alan, borçlu, borç değeri.
//Ve borcu azaltıp, arttırabileceğimiz, kontrol edebeileceğimiz fonskiyonlara ihtiyaç var.

mapping (address=> mapping (address=>uint256)) public debt;

function getDebt(address _borrower) public view returns(uint256){
    return debt [msg.sender][_borrower];
}

function incDebt(address _borrower,uint256 _amount) public {
    debt[msg.sender][_borrower] += _amount;
}

function decDebt(address _borrower,uint256 _amount) public {
    require(debt[msg.sender][_borrower] >= _amount ,"Odemek istedigin miktar borcundan fazla."); //İçeriye true olan durumu yazdık, tersinde uyarı verilir.
    debt[msg.sender][_borrower] -= _amount; //require, fazla borc girilip transact'a basıldığı an uyarı verir ve işlemi yaptırtmaz.
}



}