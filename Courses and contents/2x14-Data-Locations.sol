// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

/*
    Kodumuz EVM üzerinde yani Ethereum Virtual Machine'de çalışıyor. Bu sanal makine aynı bizim bilgisayarımız gibidir.
    Nasıl pc'de program çalıştırıldığında, ram üzerinde geçici olarak bilgi tutulur ve program bitince bilgi siliniyorsa,
    aynı mantık EVM içinde geçerlidir.


TLDR; EVM'de 3 çeşit hafıza alanı (data location) bulunur.

        storage: Bu veriler blokzincirde tutulur
        memory : Bu veriler fonksiyon çağrıldıktan itibaren EVM tarafından ayrılan özel bir bölgeder tutulur ve fonksiyon bittiğinde silinir.
        calldata: Bu veriler fonksiyon çağrılırken, çağrının (transaction) içerisinde tutulur (msg.data). Bu veriler sadece okunabilir.
        
    * bytes, string, uint256[], struct gibi referans tipleri fonksiyonlarda kullanılırken bu verilerin hangi hafıza alanından alınacağı belirtilmelidir.

    * calldata sadece fonksiyon parametreleri için kullanılabilir. CALLDATA read-only'dir.
    -> Yani calldata ile declare edilmiş bir değişken fonksiyon içinde modify edilemez sadece okunabilir.
    -> Memory ise değiştirilebilir. İkisinin farkı budur. İkisi de fonksiyon bitince silinir.
    * storage sadece fonksiyon gövdesinde kullanılabilir.

    function(string memory/calldata parameterString) external {
        string memory/storage bodyString = "";
    } //Gibi


*/


/*    
           Kontrat           <----                  Kontrata yapılan çağrı
          ---------                                ------------------------
    
    Kontrat depolama alanı           Fonksiyon için ayrılan hafıza ve çağrıdaki data alanı
    
    
    memory: Geçici hafıza
    storage: Kalıcı hafıza
    calldata: Çağrıdaki argümanlar -> ( bytes, string, array, struct )
    
    * Değer tipleri (uint, int, bool, bytes32) 
    => DEFAULT OLARAK;
    -> kontrat üzerinde -> storage, 
    -> fonksiyon içinde -> memory'dir.
    
    ***fonksiyon parametresindeki "bytes, string, array, struct" ifadelerinin ise
    ****default hali yoktur. "memory" veya "calldata" olarak declare edilmesi gerekir.
    ****calldata -> read only'dir. memory -> read only değildir, modify edilebilir.
    ***** storage > memory > calldata ile yapılan işlem ücretleri bu şekilde sıralanır. Gaz tasarrufu sağlamak istiyorsak, "doğru" tiplerde deklarasyon yapılmalı.
    
    * mapping'ler her zaman kontrat üzerinde tanımlanır ve -> storage'dadır.
*/

struct Student {
    uint8 age;
    uint16 score;
    string name;
}

contract School {
    uint256 totalStudents = 0;              // storage
    mapping(uint256 => Student) students;   // storage

    function addStudent(string calldata name, uint8 age, uint16 score) external {
        uint256 currentId = totalStudents++;
        students[currentId] = Student(age, score, name); 
    }

    function changeStudentInfoStorage(
        uint256 id,                 // memory
        string calldata newName,    // calldata
        uint8 newAge,               // memory
        uint16 newScore             // memory
    ) external {
        Student storage currentStudent = students[id];

        currentStudent.name = newName;
        currentStudent.age = newAge;
        currentStudent.score = newScore;
    }

    /*
      changeStudentInfoMemory blockchain'de değişiklik yapmaz çünkü memory'de değişiklik yapması bildirilmiş.
      Memory'de yapılan değişiklik fonksiyon bitimiyle silinecektir.
      Yukarıdaki changeStudentInfoStorage fonksiyonu ise çalışır çünkü, storage'da yani blockchain üzerinde değişiklik yapar. 
      Hatta alttaki fonskiyon remix ide tarafından uyarı alır, fonksiyonun view ile bildirilmesi gerektiğini söyler çünkü memory'de değişiklik yapıyoruz.
    */
    function changeStudentInfoMemory(
        uint256 id,                 // memory
        string calldata newName,    // calldata
        uint8 newAge,               // memory
        uint16 newScore            // memory
    ) external {
        Student memory currentStudent = students[id];

        currentStudent.name = newName;
        currentStudent.age = newAge;
        currentStudent.score = newScore;
    }

    function getStudentName(uint256 id) external view returns(string memory) { 
        return students[id].name;
    }
}

