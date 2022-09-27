// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract Variables {
    // Short Comment Line written with "//"
    
    /*
    Long Comment Line written with **
    */


    //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    // ###Fixed-Size Types - Sabit boyutlu variables###
    bool isTrue; //True yada fasle değerini alır. Default değeri = false.
    
    int number; // default olarak int256 aralığında tutar. range = " -2^255 " to " 2^255 - 1 "
    int128 number2; // aralığı kendimiz belirleyebiliriz. int256,int128,int64,int32,int16,int8 gibi.
    //int8 gibi verileri küçültmemiz optimizasyon içindir.

    uint number;  // range = " 0 " to " 2^256 - 1 " unsigned yani işaretsiz integer değerlerini alır. "-" sayılar yoktur. 
    uint64 number2; // Yine int gibi uint8,uint16... kullanabiliriz.

    address myAddress; // Soliditiy'e özel bir değişkendir. Ethereum adresleri bu değişkene atanır. 
    // 20 BYTE uzunluğundadır. Eth'de her adres 20 BYTE uzunluğundadır.

    bytes32 name = "mehmet"; // string ifadelere benzer ama valuesini hexadecimal sayılara çevirerek tutar.
    // 1'den 32 ye kadar boyut belirlemesi yapılabilir. Belirlenmezse bytes değişkeni dinamik olarak boyutunu değiştirir.
    
    bytes32 public defaultBytes32; //0x0000000000000000000000000000000000000000000000000000000000000000
    bytes public defaultBytes; //default: 0x

    //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    // ###Dynamic-Size Types - Değişken içindeki value kadar yer kaplayan variables###
    
    string name2 = "blockchain"; //bytes gibi hexedecimal değerlere çevirme işlemi yapmadan value'sini string olarak tutar.
    bytes name3; // yukarıda dediğimiz gibi 1 to 32 aralığında range vermezsek bytes'lar dinmaik olarak tuttuğu value'sinin boyutu kadar yer kaplar.

    // Arraylar " type [size] name; " parantez kullanarak değişkenleri değişken dizilerine çeviririz. Bütünüyle bir array/diziyi ifade eder.
    uint[4] numbers = [1,2,3,4]; //string,int,bytes dizileride oluşturabiliriz.
    uint[] numbers2 ; // size'ı verilmezse dinamik boyutlu array oluşturmuş oluruz.
    
    mapping(uint => string) list; // Bu ne demek: ben sana uint tipinde bir değer vereceğim o değer bir string tutacak. Bu yapının adıda list'dir.
    //Bu ne demek: list adlı değişken 3 valuesini "alim" string ifadesi ile eşleştirdi, bağdaştırdı. 3=>alim. üç alime götürür. 
    // Yani biz list adlı mapping variable'ına  3 değerini input olarak verirsek bize "alim" output'unu verir.

    // Default değerler nelerdir?
    // Unassigned variables have a default value
    bool public defaultBoo; // false
    uint public defaultUint; // 0
    int public defaultInt; // 0
    address public defaultAddr; // 0x0000000000000000000000000000000000000000

    //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    // ###User-Defined Value Types - Kullanıcı Tarafından Oluşturulan Değişkenler###
    //Daha çok değişken koleksiyonları çünkü içinde uint,string,int gibi tiplerin toplamında oluşan bir yapı oluşturuyoruz.
    //Aşağıdaki şekilde özel veri tipleri oluşturabiliriz.
    //###struct####
    struct Human {
        uint id;
        string name;
        uint age;
        address adres;
    }
    mapping(uint => Human) list2; // Humanlardan oluşan bir liste.
    Human person1;
    
    /*
    person1.id = 2;
    person1.name = "mehmet";
    person1.age = 21
    person1.adres = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; */
    
    //###enum####
    enum trafficLight { 
                        
        RED,
        YELLOW,
        GREEN
    }
    // Ne işe yarar? Mesela block numarası belli bir sayıya ulaşınca trafficLight green olsun diyebiliriz.
    // Ayrıca if(trafficLight == RED ) diyerek kontroller sağlayabilmemize olanak sağlar. Kullanım nedeni okunaklı ve anlaşılır olmasıdır.
    /* trafficLight */

    //#### ETHER TANIMLAMASI #### Sisten ether üzerinde olduğu için büyük ihtimalle ether transferi yapmamız gerekecek.

    // 1 ether = 10^18 wei 'ye tekabul eder. en küçük birim wei'dir.
    // Kod yazarken 1 ether göndermek için (10 üzeri 18 wei) 1000000.. wei şeklinde yazmaya gerek yoktur.
    //"1 ether" yazdığımızda  10 üzeri 18 tane wei gönderdiğimiz otomatik olarak algılanır.
    // 1 gwei = 10^9 wei 'dir. Yani yarım ethereum 'a tekabul eder.

    // ### ZAMAN BİRİMLERİ ###

    
    1 = 1 seconds;
    1 minutes = 60 seconds;
    1 hours = 60 minutes = 3600 seconds;
    1 days;
    1 weeks;
    

    // CTRL + K + C kısayolu ile seçilen metinler yorum satırı yapılır.
    // CTRL + K + U kısayolu ile seçilen syorum satırları normal metine çevrilebilir.

    //LOCAL VARIABLES
    //genel olarak contract ile alakalı değişkenlerdir.

    //GLOBAL VARIABLES
    //genel olarak blockchain ile alakalı değişkenlerdir. retun block.number; kaçıncı blokta olduğmuzu döndür.
    //block.difficult blockchainin zorluğu
    //block.gaslimit
    //return msg.sender; gönderici adresini döndür.
/*
    There are 3 types of variables in Solidity:

    1.State Variables
    Declared outside the function.
    Stored on the blockchain.
    
    2.Local Variables:
    Not stored on the blockchain.
    Declared inside the function.
    
    3.Global:
    Blockchain related variables.
    
*/

 // global ("provides information" about the blockchain)

contract Variables {
    // State variables are "stored" on the blockchain.
    string public text = "Hello";
    uint public num = 123;

    function doSomething() public {
        // Local variables are "not saved" to the blockchain.
        uint i = 456;

        // Here are some global variables
        uint timestamp = block.timestamp; // Current block timestamp
        address sender = msg.sender; // address of the caller
    }
}

}
