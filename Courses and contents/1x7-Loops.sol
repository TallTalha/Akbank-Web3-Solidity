// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract Loops{

    uint256[15] public numbers0;
    uint256[15] public numbers1;
    bool public crash = true;

    function ForLoop() public {
        uint256[15]  memory nums = numbers0; // Bu şekilde blockchaindeki state variable'lın her indeksine devamlı modify yapmaktan kurtuluruz.
        //Loopun tekrarı kadar modify yapmadığımız için gaz ücretinde tasarruf ederiz diye düşündüm ama öyle değilmiş.
        //ücretler fonsiyonun sonundaki satırda yazıyor.
        
        for(uint256 i=0;i<nums.length;i++){
            // if(i==9) continue ;
            // if(i==9) break;
            nums[i]=i;
        }

        numbers0 = nums; //Burada tek modify ile gaz ücretinde tasarruf edemedik. Aşağıda ücretler yazıyor.
    }
    //tek modify ile; gas : 389254 , transaction cost: 338481 , execution cost : 338481
    //loop sayısı kadar modify ile; gas:387592, transaction cost: 337036, execution cost :337036
    //Düşündüğüm gibi değilmiş. loop'ta numbers0[i] = i; yapınca gaz ücreti daha az oldu.
    //Belki kendi memory'mizde yaptığımız için daha hızlı olmuştur. Video sahiplerine sordum, cevaplanırsa not eklerim.

    function getArr0()view public returns(uint256[15] memory) {
        return numbers0;
    }

    function WhileLoop() public {
        uint256 i=0;
        
        while (i<numbers1.length){
            numbers1[i]=i;
            i++;
        }
        //While kullanılması önerilmez.Çünkü sonsuz döngüye girilmesi şunlara sebep olur.
        //Eğer blockchainde modify içeren bir while döngümüz, sonsuz döngüye girerse bu işlemin ücreti sonsuz gaz anlamına gelir.
        //Sonsuz gaz ücreti ödenemeyeceği için transcation gerçekleşemez ve hataya sebep olur.
        //Remix ide üzerinde yaptığımız için burada yaptığımız sonsuz döngü web tarayıcımızın çökmesine sebep olur.
        

    }

    function sonsuzGaz() public {

        while(true){
            if(crash != true) crash=true;
            else crash=false;
        }
    }


    function getArr1()view public returns(uint256[15] memory) {
        return numbers1;
    }


}