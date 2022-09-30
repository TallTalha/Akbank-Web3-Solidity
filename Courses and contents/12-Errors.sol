// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;


//Hata methotlarını kullnarak bazı fonksiyonların çalışmasını engelleyecez ve kullanıcıya mesaj verebilecez.

contract Errors{
    uint256 public totalBalance;
    //Aşağıdaki paymen fonksiyonunu çalıştırdık ama yatırma yapıldığı nasıl anlaşılacak ?
    //Bunun için, kontratta bulunan toplam bakiyeyi gösteren, totalBalance değişkenini oluşturduk.
    //Aslında, doğrudan global variable'lar ile kontrat adresine erişip, kontratın bakiyesini sorgulayabilirdik.
    //Peki bunu yapmayıp, neden bir değişken tuttarak kontrata yük bindiridk? Çünkü kontarata para girişi ve çıkışını sadece aşağıda yazdığımız fonksiyonlar
    //değil, bu fonksiyonlar dışında da kontrata para girişi ve çıkışı yapılabiliyor, bunu recieve ve fallback fonksiyonları ile engellenebilir ama bazı açıkları var.
    //Yani bu fonskiyonlar ile "tammen" para girişini engelleyemiyoruz, kaçak bir şekilde payment yaptıran bir yol var, 
    //bunu ilerideki güvenlik açıkları derslerinde işleyeceğiz.
    //Kontratlarda self-distruct metodunu çağırarak, kontrat içinde payment yapılmış miktarı başka bir kontrata aktardığımızda, bu kontrata para girişi olmayacağını,
    //receieve veya fallback fonksiyonu "tammen" engelleyemiyor, bu yüzden burada tutulacak bir totalBalance değişkeni oluşturup,
    //kontratın asıl bakiyesini yok saymak "daha güvenli bir kod sağlıyor".
    
    error Deny(string reason);
    //receive ve fallbak aracılığı ile payment yapılmasını reddetmek için "Deny" adlı error yazdık.
    receive() external payable {
        revert Deny("No direct payment.");

    }
    fallback() external payable {
        revert Deny("No direct payment.");
    }
    
    mapping (address => uint256) public userBalance;

    error ExceedingAmount(address user,uint256 exceedingAmount);
    

    //Kontrat içindeki mantıksal hataları engllemek için "assert" kullanıyoruz. Kontratta hiç çalışmayacağından emin olduğumuz yerlere
    //ekstra bir güvenlik önlemi olması amacıyla "assert" yerleştiriyoruzki hata oluşmasın.

    //Ether cinsinden işlem yapılacağı için bir value parametresine gerek yok.
    //"msg.value" global variable'ı bize o an pay edilecek değerin bilgisini verir.
    //payable: ether ödemesi alacağı için payable ile declare edilir.
    function pay() external payable noZero(msg.value) {
        require(msg.value == 1 ether,"Only payments in 1 ether");//Bunu yazınca noZero modifier'ına bir nevi gerek kalmadı. Örnek olsun diye yazdık.

        totalBalance += 1 ether; //1 ether = 1e18 ile gösterilebilir. Yarım ether için, 5'in yanına 17tane sıfır yazılmalı.
        userBalance[msg.sender] += 1 ether;
    }
    //Burada para girişi olmayacağı için, payable declare edilmez ve parametre alır.
    //withdraw/çekme
    function withdraw(uint256 _amount) external noZero(_amount) {
        uint256 initialBalance = totalBalance;
        //require(userBalance[msg.sender] => _amount, "Insufficient balance"); 
        if(userBalance[msg.sender] < _amount){
            //revert("Insufficient balance.")
            revert ExceedingAmount(msg.sender,_amount - userBalance[msg.sender]);
            //Bu error tipini, sadece string uyarı vermek istemiyor, özel bir tipte uyarı vermek istiyorsak kullanıyoruz.
        }

        totalBalance -= _amount;
        userBalance[msg.sender] -= _amount;
        //Çekme yapabilmek için address değişkenini payable ile nitelendirmemiz/declare gerekli.
        payable(msg.sender).transfer(_amount);

        assert(totalBalance < initialBalance);
        //Kontrat içindeki mantıksal hataları engllemek için "assert" kullanıyoruz. Kontratta hiç çalışmayacağından emin olduğumuz yerlere
        //ekstra bir güvenlik önlemi olması amacıyla "assert" yerleştiriyoruzki hata oluşmasın. Bu hata kullanıcı kaynaklı değildir bizim yazdığımız
        //kod ile oluşan hatadır. çekmek işlemi gerçekleşirse total balance kesin azalacaktır ama biz yinede güvenlik amacıyla "assert" kullandık.
    }
    //Sıfır etherlik para yatırma veya 0 birimlik para çekiminin olmaması için bir modifier tanımlıyoruz.
    modifier noZero (uint256 _amount){
        require(_amount > 0,"Zero amount of transactions cannot be executed."); //require: Hata mesajları verebileceğimiz Errors'lardan biri.
        _;
    }

}