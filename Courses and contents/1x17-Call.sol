// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

/*

Diğer sözleşmelerdeki fonksiyonları çağırırken "call" işlevi kullanılır.
Ama low level bir fonksiyondur, yani diğer sözleşmelerdeki fonskiyonları çağırıken kullanılması önerilmez.
"call" fonksiyonunun önerilen kullanım yeri -> diğer sözleşmelerin "fallback" fonksiyonlarını tetiklemek için 
yada doğrudan  ether değeri göndermek için kullanılması önerilir.

Ama "illa" "call" ile çağırmak istersek, diğer fonksiyonların parametrelerini biliyorsak çağırabiliriz. 
Yanlış adlı fonksiyon çağrıları "fallback"i tetikler.
Ve "call" ile kontratların "abi"'larına ihtiyaç duymadan kontratları çağırabiliriz.


*/

contract Test {
    uint256 public total = 0; //balance
    uint256 public fallbackCalled = 0; //fallback kaç kez tetiklendi
    string public incrementer; //Arttıtan kim

    fallback() external payable {
        fallbackCalled += 1;
    }

    function inc(uint256 _amount, string memory _incrementer) external returns(uint256) {
        total += _amount;
        incrementer = _incrementer;

        return total;
    } 
}

contract Caller {
    
    //Test kontratında bulunan inc() fonksiyonunun parametrelerini aynen yazdık. _contract ve returns(bool)'u kendimiz ekledik.

    function testCall(address _contract, uint256 _amount, string memory _incrementer) external returns (bool, uint256) {
        
        //call yaptığımızda dönen ilk değer booldur sonrasında asıl fonksiyonun return değerleri encode'lu olarak döner, bytes'ta tutulur.
       (bool err, bytes memory res) = _contract.call(abi.encodeWithSignature("inc(uint256, string)", _amount, _incrementer));
         //----------------------------------------------------------------->"inc" yerine yanlış bir isim verseydik fallback tetiklenirdi.
        //Burada encode'lanmış total değişkenini decode ile uint256 formatına çevirdik.
        uint256 _total = abi.decode(res, (uint256));
        return (err, _total);
    }

    //Fallback'i tetikleme
    function payToFallback(address _contract) external payable {
        
        (bool err,) = _contract.call{value: msg.value}("");

        if(!err) revert();
    }


}