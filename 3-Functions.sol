// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract Functions {
    uint luckyNumber = 7;
    //Fonksiyonlar statete tutulan verilerin değiştirilmesinde daha çok kullanılır.

    //OKUMA
    function getNumb() public view returns(uint) { 
        return luckyNumber; 
    }
    //public: kullanıcıya açık, view : okuma işlemi yapılacaksa bildirilmeli
    //returns( dönmesini istediğimiz değişkenlerin tipini belirtmemiz gerekiyor) 
    // uint public luckyNumber; olarak tanımlasaydık deploy ettikten sonra yine ulaşabilirdik.

    //-----------------------------------------------------
    //YAZMA
    function setLuckyNumber(uint newNumb) public {
        luckyNumber = newNumb; 
    }
    // Deploy ettikten sonra fark edeceksinki set fonksiyonunun butonu turuncu renkte.  
    //Turuncu renkli olmasının sebebi, ücretli olmasıdır.
    //State variables değiştiriyoruz yani blockchain üzerinde kayıtlı bir veriyi değiştiriyoruz
    //Bu yüzden blockchain bizden gaz ücreti alıyor. Turuncu = gas fee
    // Hatta Deploy sekmesinde account kısmına gelirsen ilk başta 99...99 olan ether miktarının azalmış olduğunu göreceksein.
    //Bunun sebebi: kodlarını blokzincire deploy etmen ve blockchain üzerindeki verilerde değişiklik yapman.
    
    //-----------------------------------------------------
    //ÇOKLU OKUMA
    function multiGET() public pure returns(uint, bool, bool, bytes1){
        
        return (5, true, false, 0x01);
    }
    //pure : state veya global variable'lar ile işim yok. Local variable'lar ile işim var diyorsan pure ile bildirilmeli.
    function multiGET2() public pure returns(uint x, bool y, bool z, bytes1 a){
        x = 6;
        y=false;
        z=true;
        a = 0x01;
    }
    
    //--------------------------------------------------------
    uint public sayi = 5;
    function setSayi(uint newSayi) public {
        sayi = newSayi; 
    }
    //State'te değişiklik yapıyorsak sadece public yazmak yeterli
    function getSayi(uint x) public view returns(uint){
        return x+sayi; 
    }
    //Bu bir okuma işlemi ve döndürme işlemdir. Toplama ile blockchainde değişiklik yapmış olmayız.
    //Bu yüzden gas fee ödememize gerek yoktur.

    //KISACA 
     uint public po = 1;
     // Promise not to modify the state.
     function addToX(uint y) public view returns (uint) {
        return po + y;
    }

    // Promise not to modify or read from the state.
    function add(uint i, uint j) public pure returns (uint) {
        return i + j;
    }
    //soru 1 : global veya state variables'lar ile işin var mı ? 
    //cevap 1: Var. O zaman -> Okuma yapacaksan = view ile bildirmelisin, okuma yoksa = public,external,internal,private.
    //cevap 2: Yok. O zaman sen Local Varabiles ile işin var -> pure ile bildirmelisin.
    //return işlemi yapacaksan hangi tiplerde veri döndürleceğini returns(...) ile bildirmelisin.

    //------------------------------------------------------
    //public, external, internal, private nedir.

    //++++++++++++++++++++++++++++
    //PUBLIC : Kullanıcılar ve kontratlar çağırabilir. 
    //Örneğin A ve B adlı iki kontratın var. A kontratında yazılan public function, B'de çağrılabilir.

    //++++++++++++++++++++++++++++
    //PRIVATE : Fonksiyon bulunduğu kontratına özeldir. Kullanıcılar çağıramaz.

    function  topla(uint x, uint y) private pure returns (uint){
        return x+y;
    } 

    function fakeTopla(uint a, uint b) public pure returns (uint){
      return topla(a,b); 
    }
    //fakeTopla kontratı, topla kontratını çağırabilir çünkü aynı kontratın içindeler.
    // Ve private olduğu için Deploy edildiğinde kullanıcılar göremez.
    // Ancak kullanıcılar public olan fakeTopla'yı kullanabilirler.
    // Bu sayede kullanıcılar fakeTopla'nın toplama yaptığını sanar ama 
    //toplama işlemini topla fonksiyonu yapmış olur. fakeTopla sadece return eder.

    //+++++++++++++++++++++++++++
    //INTERNAL : Kullanıcılar göremez. Fakar A ve B kontratlarımız olsun. A kontratında internal fonksiyonumuz bulunsun.
    //B kontratı internal fonksiyonu direkt kullanamaz. Ayrı olaraktan A kontratını miras alması gerekir.
    //B kontratı A'nın subclass'ı haline gelirse yani miras alırsa, A'daki internal fonksiyonu çağırabilir.

    //+++++++++++++++++++++++++++
    //EXTERNAL : Kullanıcılar çağırabilir. Kontrat içinde çağrılamaz. Vatan haini.

    //İçeride kullanmayacaksak External kullanılmalı, bu gaz tasarrufu yapmamızı sağlıyor.
}