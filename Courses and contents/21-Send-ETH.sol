// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;
/*
 Smart Contract Developer Bootcamp - İTÜ Blockchain

    Bu dersimizde kontrata ve hesaplara transfer yapmanın yollarını inceledik. Receive ve Fallback fonksiyonları inceledik.

***payable: Ether transfer edebileceğimiz fonskiyon ve adresleri bildirir. 

***Bir fonksiyona ether göndermek için fonksiyonun payable olarak nitelenmiş olması gerekir

    function fName() public payable {
        /// @dev fonksiyonun işlevleri...
    }

***Bir adrese ether gönderebilmek için adresin payable olarak nitelenmiş olması gerekir.

    function fName() public  {
        payable(0x...).transfer(amount);
    }

----Ether göndermenin 3 farklı yolu:----

    1-transfer: 2300 gas sınırı vardır, receive veya fallback yoksa throws error/error fırlatır
    2-send: 2300 gas sınırı vardır, receive veya fallback yoksa bool döndürür
    3-call: ETH aktarmanın önerilen yoludur, çünkü gönderilecek gaz miktarını ayarlayabiliriz.receive veya fallback yoksa bool döndürür.
    
    Call için uyarı:
    However, you should be extra careful when using “call” in a contract since it allows reentrancy attacks. 
    If the sender contract is improperly coded, it can result in draining larger amounts of funds from it than planned.
    TR:
    Ancak, yeniden giriş saldırılarına izin verdiği/allows reentrancy attacks için bir sözleşmede "call" kullanırken daha dikkatli olmalısınız. 
    Gönderen sözleşmesi uygunsuz bir şekilde kodlanmışsa, planlanandan daha büyük miktarda fon boşaltılmasına neden olabilir.

||||> ÖNEMLİ <||||
|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  Kontratların """fonksiyonlar dışında ether alabilmesi""" için """"receive ya da fallback fonksiyonlarından en az birisinin tanımlanmış olması gerekir."""" |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------|

Ether alan bir sözleşme aşağıdaki işlevlerden "en az birine" sahip olmalıdır;

=> receive() external payable {}

=> fallback() external payable {}

--------Eğer msg.data boş ise receive, değil ise fallback fonksiyonu çalışır.--------------
If neither a receive Ether nor a payable fallback function is present, the contract cannot receive Ether through regular transactions and throws an exception.
TR:
Ne bir "receive" ether alma, ne de ödenebilir bir "fallback" işlevi mevcut değilse, 
//sözleşme düzenli işlemler(receive,fallback) yoluyla ether alamaz ve bir istisna atar.


*********** Hangi fonksiyon çağırılacak, fallback() or receive()? ***************
*                                                                               *                                
*                                Ether gönder                                   *                                       
*                                     |                                         *
*                               msg.data boş mu?                                *
*                                    / \                                        *
*                                 evet hayır                                    *
*                                  /     \                                      *      
*                      receive() var mı?  fallback()                            *
*                               /   \                                           *
*                             evet hayır                                        *
*                              /      \                                         *
*                          receive()   fallback()                               *
*                                                                               *
*********************************************************************************
*/
//Banka kontratı yazacağız.
//Bu kontratta insanlar banka kontratına etherlerini gönderebilsin ve istedği zaman çekebilsin.
contract Bank {
    mapping (address => uint) balances;//Kişilerin bakiye bilgilerini tuttuk.

    function sendEtherToContract() external payable { //Ether gönderimi yapabilmke için payable ile bildirim yaptık.
        require(msg.value > 0,"You cannot send zero ether.");
        balances[msg.sender] += msg.value;
    }

    function showUserBalance() external view returns(uint){
        return balances[msg.sender];
    }

    function withdraw(address payable _to,uint _amount) external {
       
        require(balances[msg.sender]>_amount,"Insufficient balance.");
        require(_amount>0,"You cannot withdraw zero Ether.");
       
        _to.transfer(_amount);//istenilen miktarı _to adresine trasfer eder.
 }

      //Transfer fonksiyonu aynı zamanda, "yetersiz bakiye" durumunu kendisi otomatik saptayabiliyor.
     //require(balances[msg.sender]>_amount,"Insufficient balance.");
    //Bu require fonskiyonunun yaptığı işi yapıyor. Hata mesajı olarak aşağıdaki /*...*/ ile yorum satırına alınmış uyarıyı verir.
    /*
    revert
	        The transaction has been reverted to the initial state.                      "tırnak işaretlerini ben koydum"
            Note: The called function should be payable "if you send value" "and the value" "you send" "should be" "less than your current balance."
            Debug the transaction to get more information.
    */

    //transfer();
    //revert ile yukarıdaki gibi bilgi verir.

    //_to.send(_amount);
    //bool değeri döndürür, yani bize true/false bilgisi verir.

    //call(); ise iki değer dönderir. Önceilkle bir bool döndürür, sonrasında bir data döndürür (bytes memory data). ve gaz limiti ayarlanabilir.
    //(bool _state, bytes memory _data) = _to.call{value: _amount, gas: 2400}(""); şeklinde tanımlanır.



    //Sadece yukarıdaki üç fonksiyon varken "Low level interactions" kısmından transaction yapmaya çalışırsak bize şu uyarıyı verir:
    //"In order to receive Ether transfer/ether transferi almak için" -> the contract should have either 'receive' or payable 'fallback' function.
    //Fonskiyonlar olmadanda kontrata ether gönderebilmek için, 'receive' or payable 'fallback' function var olmalı.
    //Bu fonksiyonlar ne için kullanılır, eğer kontrata bir ether aktarımı gelirse, kontratın bu durumda ne yapacağını belirleyebilmemizi sağlıyor.

//----------------------------RECEIVE-------------------------------
    uint public receiveCount;
    receive () external payable {
        //Ether geldiğinde kendiniliğinden çalışır.
        //Biz, bu ether geldiği durumda, ne yapması gerektiğini belirleyecez.
        receiveCount +=1;

    }
    //Artık "Low level interactions" kısmından transaction yapabiliyoruz, receiveCount'ın arttığını görebiliriz.
    //Ama showUserBalance'ın bilgisini istediğimizde "0" görünecektir çünkü receive içinde böyle bir tanımlama yapmadık sadece counter 1 artıyor.


//----------------------------FALLBACK-------------------------------
    //Fallback'in receive'den farkı: receive'de Ether,finney,gwei,wei gibi parasal birimler aktarabilirken fallback ile hexedecimal data da aktarılabiliyor.
    //Fallback olmadan, "Low level interactions" kısmında "calldata" alanına bir hexedecimal data yazarak gönderirsek, fallback bulunmadığı için hata alırız.
    //Receive olmadan da para aktarımı yapılabilir, fallback tek başına hem datayı hem parasal aktarımları saptayabilir.
    //Hatta hem hexedecimal data hem de parasal birim gönderilirse receive çalışmaz, sadece fallback çalışır.
    uint public fallbackCount;
    fallback() external payable {
        fallbackCount += 1;
    }

    //Uzun uzun anlatmaya gerek yok. Hex Data ve Para = Fallback , Sadece Para = Receive. Ve Receive yoksa, FallBack aynı işi yapma kabiliyetinde.
    // Receive ve Fallback'in tetiklendiği durumlar belli ama içerisine yazacağımız kod bize bağlı, farklı amaçlar için kullanılabilir.



}