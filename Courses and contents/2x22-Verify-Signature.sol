// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

// Verify Siganture = İmzayı Doğrulama

//Bir imzayı doğrulamak için solidity'de 4 adım mevcuttur.
/*
1- Message to sign : kullanıcı bir mesajı imzalar
2- hash(message) : Mesaj hash fonskiyonu ile işlenir
3- sign(hash(message) | offchin: Kullanıcı hash ile işlenmiş olan mesajı da imzalar. Bu imza, akıllı sözlmeşenin dışında yapılır. Cüzdan kullanarak yapılabilir.
4- ecrecover(hash(message), signature) == signer : Bu imza karşılaştırması, akıllı sözleşme içinde, ecrecover fonksiyonu ile yapılır.
***ecrecover mesajı imzalayan kişiyi döndürür. Doğruluk kontrol edilmiş olur.
*/

//İmza doğrulama nasıl yapılır?
contract VerifySign{
    function verify(address _signer,string memory _message, bytes memory _signature) external pure returns(bool) {

        bytes32 messageHashed = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHashed);
        return recover(ethSignedMessageHash, _signature) == _signer;
    }

    function getMessageHash(string memory _message) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_message));
        //Burada output edilen hash'i metamask kullanarak imzalaycağız. Nasıl yapılacağı kodun en sonunda.
    }
    
    function getEthSignedMessageHash(bytes32 _messageHashed) public pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",_messageHashed));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns(address) {
        //v,r,s dijital imzalar için kullanılan kriptografik parametrelerdir
        //v parametresi ethereum'a özel bir parametredir.
        //bu parametreler hakkında endişlenmenize gerek yok. Yapmamız gereken ecrecover adlı fonksiyona iletmektir.
        (bytes32 r, bytes32 s, uint8 v) = _split(_signature);
        //split'i sonra yazacağız, imzayı 3 parametreye bölecek.
        return  ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function _split(bytes memory _signature) internal  pure returns (bytes32 r, bytes32 s, uint8 v){
         //total uzunluk 32+32+1 (uint8bit = 1 byte) olduğu için 65 byte'lık karşılaştırma yaparak, doğrulama yapmamız gerekli.
         require(_signature.length == 65, "invalid signature length.");
         //artık imzayı v,r,s'e dönüştürebiliriz. Bunun için Assembly kullanmamız gerekli
         //_signature dinmaik bir veri. ve bu _signature orijinal imza değildir. İmzanın nerede depolandığına dair bir pointer'dır. İmza memory'de saklanır.

         assembly {
             r := mload(add(_signature, 32))
             //_signature pointerdir, burada yaptığımız atlama direkt imza üzerinde bir atlamaya sebep olmaz.
             // ilk 32 byte dizinin uzunluğunu tutar bu yüzden "add(_signature, 32)" ile atlama yaparak, imzaya ulaşmamız gerekli.
             //r 32 bytes olduğu için imzanın birinci 32 byte'lık kısmı r'ye atanmış olur.
             
             s := mload(add(_signature, 64)) //64 bit atlayarak ikinci 32byte'ı s'e atamış olduk.
             
             v := byte(0, mload(add(_signature, 96))) //96 byte atlayarak 65.byte'ı v'ye atamış olduk
             //96'dan sonra gelen 32byte'lık veriye ihtiyacamız olmadığı için sadece ilk byte'ı alan "byte(0,..)" kodundan yararlandık.
         }
        //return etmemize gerek yok, returns kısmında adlandırmaları önceden vermiştik. Değerler direkt okundu.
    }

    //--------------------------YUKARIDAKI KODLAR PRATİKTE NASIL UYGULANIR-----------------------------------

     //getMessageHash fonksiyonuna "gizli mesaj" stringini hash'lemesini istedim.
        //Output olarak bunu verdi: 0xaa54f4741a463044953dbb8340427498c5a0cd9466096deeb66ccfa061cebbdb
    
    //Metamask ile bu outputu yani hash'lenmiş mesajı imzalamak için aşağıdaki adımları izledim.
        //F12 -> ethereum.enable() -> account = "" -> hash = "" -> ethereum.request({method: "personal_sign", params: [account,hash]})
        //aşağıdaki hash = "..." ksımına yukarıdaki outputu girdim. account kısmına metamask account adresimi girdim.
        // -> Promise {<pending>} -> [[PromiseResult]]: "..." 
        //"..." kısmında, hash fonksiyonundan geçirilmiş mesajı imzalamam sonucunda çıkan, result bulunmakta.
    
    //Promise Result'ta aşağıdaki yazı output edildi:
    //0x6302a324c6dc17b577c6c149c58d5a6bd7e86be6bbbdbbc8f09febd56c08028a02ffa46eecf87bab795f5924467c046ac3913fc5a2bee088dbb3c772813e25191b
        
    //recover'da signature kısmına üstteki uzun outputu ve ethSignedMessageHash ile hash'lenmiş veriyi input'a girdiğim zaman
        //output olarak metamask account'umun adresini verdi.
    
    //Verify kısmına _signer = metamask account , _message = orijinal mesaj , _signature kısmına uzun output girildiğinde
        //true bilgisi döndürüleceklerdir. İnputlardan herhangi birinde yanlış olursa false döndürülür.
    

}

