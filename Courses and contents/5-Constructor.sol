// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract Constructor{
    //Sadece başlangıçta çalışan özel fonksiyondur.

    string public tokenName;
    uint public totalSupply;
    //Yukarıdakı varibale'ların başlangıçta belirlenmesini istiyoruz.
    //Bu durumda constructor'u kullanıcaz.

    /*
    constructor(string memory name, uint number) {
        tokenName = name;
        totalSupply = number;
    }
    */

    //Eth blockzinricinde kodumuzu deploy etmeden önce constructor bloğu bir kere çağrılır.
    //Sonrasında contructor'a bir daha erişemeyiz. Yani sadece başlangıçta çalışır.
    //Yukarıdaki yazılar önbilgiydi. Şimdi deploy kısmına gelirsen kodu hemen deploy etmene izin vermez.
    //Hatanın sebebi senin kodunda bir constructor bloğunun var olması.
    //Deploy kısmının yanındaki boşluğa constructr'ın parametrelerini girersen deploy etmene izin verir.
    //Hatta girdi boşluğun yanındaki yön işaretine tıklarsan neleri girmen gerektiğini daha rahat görebilirsin.
    
    //+++++++++++++++++++++++++++
    //Artık constructor'u kullanamıyacağız ama bir set() fonksiyonu yazarsak değerleri anlık değiştirebiliriz.
    // Mesela:  function set(uint newX) public { totalSupply = newX; } gibi bir fonksiyobn ile değiştirebiliriz.

    //+++++++++++++++++++++++++++DEĞİŞMESİN İSTİYORSAK+++++++++++++++++++++++++++++++++++++
    //Yukarıdaki gibi hem başlangıçta constructor ile belirlensin 
    //ama sonradan bir fonksiyon ile değiştirilmesini istemiyorsak ne yapmalıyız?

    //constant, immutable
    //eğer yukarıdaki nitelikler ile bir variable bildirilirse bir daha değişemez.

    
    //-----------------------------------
    //Contructor'da değer ataması yapıldıktan sonra bir daha değişmemesini istiyorsak:
    //IMMUTABLE
    uint public immutable afterPrivateNumber; //Önce bu şekilde değer vermeden tanımlanır.
    
    constructor(uint numb){
        afterPrivateNumber = numb;
    }
    
    
    
    //---------------------------------------
    //Tanımlandığı anda değer atanıp bir daha değişmemesini istiyorsak:
    //CONSTANT
    uint public constant privateNumber = 10; 
    //Bu şekilde tanımladıktan sonra seşitliğin karşısına alacağı değer vermek zorundayız. 
    //Sonrasında bu variable değiştirilemez.
}