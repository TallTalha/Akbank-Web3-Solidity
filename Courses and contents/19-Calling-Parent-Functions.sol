// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//ITU Blockchain Inheritance videosunda aynı içerik toplu olarak işlendi.

/*
Parent'ların fonskiyonları nasıl kullanılır;
1- direkt isimlendirme: E.work();
2- super ile isimlendirme: super.work();
----ikiside aynı işlevi görür, birden fazla parent varsa super her parent için ayrı çalışır----
----En altta birden fazla parent ile super çağrımı yapılırsa ne oluyor işledik----


    E
   / \
  F   G
   \ /
    H
    
    Şeklinde bir Parent-child örneğini aşağıda uyguladık.
*/

contract E {
    event Log ( string message ) ;

    function foo ( ) public virtual {
        emit Log ( " E . foo " ) ;
    }
    function bar ( ) public virtual {
        emit Log ( " E.bar " ) ;
   }
}

contract F is E {
   //E'nin fonksiyonlarını miras aldık ve override ettik.
   function foo ( ) public virtual override {
        emit Log ( " F.foo " ) ; 
   }
    function bar ( ) public virtual override {
        emit Log ( " F.bar " ) ;
   }
}

contract G is E {
    //Aynı şekilde burada da miras alıp override ettik.
    function foo ( ) public virtual override {
        emit Log ( " G . foo " ) ;
        E.foo();
    }
   
    function bar ( ) public virtual override {
        emit Log("G.bar") ;
        super.bar(); //Burada ayrıca Parent'ımızın bar() fonksiyonunu çalıştırdık. Yani E.bar() çalıştı.
   }
}

contract H is F , G {

    function foo ( ) public override ( F , G ) {
        F.foo(); //Burada directly isimlendirme yaparak F.foo()'yu çalıştırdık.
   }
    function bar ( ) public override ( F , G ) {
       super.bar(); // Hem F hemde G 'nin bar() fonskiyonlarını çalıştırır.
   }

}