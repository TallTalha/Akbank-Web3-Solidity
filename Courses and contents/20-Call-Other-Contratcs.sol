// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;


contract  TestContract{
    //CallTestContract'ından çağrı yaparak:
    //Aşağıdaki değişkenleri değişitirecez ve fonksiyonları kullanıcağız.
    uint public x;
    uint public value;

    function setX(uint _x) external  {
        x = _x;
    }
    
    function getX ( ) external view returns ( uint ) {
        return x ;
    }
    
    function setXandReceiveEther ( uint _x ) external payable {
        x = _x ;
        value = msg.value ;
    }
    
    function getXandValue ( ) external view returns ( uint , uint ) {
        return ( x , value ) ;
    } 


}

contract CallTestContract {
/*
    function setX(address _test, uint _x) external {
        
        TestContract(_test).setX(_x); 
            ^
            |
        //TestContract yazarak, bir nevi TestContract'ı deploy edip, setX fonksiyonunu kullanmış olduk.
        //Burada yaptımğımız atama işlemi TestContract'In x adlı state variable'ını değiştirir.
        //Eğer aşağıdaki gibi parametre olarak TestContract'ı yazarsak statik bir fonksiyon oluştumuş oluruz.
    }
*/
    
    function setX(TestContract _test, uint _x) external {
        _test.setX(_x); //TestContract'ı parametre olarak aldığımızda direkt deploy edildi, _test üerinden setX artık kullanılabilir.
        //derdimizi ingilizce anlatacak olursak: The setX() function can be initialize  in the _test variable now.
    }
    
    //Dedimiğimiz gibi parametre statik olacaksa direkt kontrat adını yaz.
    //Parametre değişken olacaksa address bilgisi parametre olarak alınmalı.
    //Eğer verilen input adresi, deploy edilsin diye yazdığımız kontartın adresi ile uyuşmazsa fonksiyon çağırılamaz.
    function getX(address _test) external view returns(uint){
        uint x= TestContract(_test).getX();
        return x; 
        // return TestContract(_test).getX();
        //veya fonksiyonu ayzarken "returns(uint x)" olarak belirtiriz. 
        //Fonskiyon içine de: "x = TestContract(_test).getX();" yazarsak return işlemi aynı şekilde gerçekleşir.

    }

    function sendXandSendEther(address _test, uint _x) external  payable {
        
        TestContract(_test).setXandReceiveEther{value: msg.value}(_x);
        //CallTestContract üzerindeki bir fonksiyondan, TestContrat'ta bulunan bir fonksiyonu çağırdık ve parametlerini girdik.
        //Çağırma işleminde, çağırdığımız kontratı deploy ettiğimiz için aslında o kontratın depoladığı bilgilerde değiştirmiş olduk.
        //Yani başka bir kontrat ile bir kontrata erişip, hem özelliklerini kullandık hemde modify yapabildik.

    }

    function getXandEtherValue(address _test) external view returns(uint x,uint value) {
        (x , value) = TestContract(_test).getXandValue();
    }



    
}


