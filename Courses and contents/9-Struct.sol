// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract StructEnum {
    //Şipariş alma süreci ve mağza sahibinin bunu yönetmesi. 
    //Struct order, enum status, createOrder, changeStatus, getOrder, updateZip oluşturuldu. 
    //Stringler, arrayler, bytlelar, structlar fonksiyona parametre olarak gönderilirken memory/storage olarak declare edilmeli.
    
    //Status bilgileri
    enum Status{
        Taken,
        Preparing,
        Boxed,
        Shipped
    }
    //Order struct'ı oluşturalım.
    struct Order{
        address customer;
        string zipCode;
        uint256[] products;
        Status status;
    }
    //Orderların bulunudğu bir array, mağza admin'i oluşturalım.
    Order[] public orders;
    address public owner;
    constructor(){ //Kontratı ilk çalıştıran mağza yöneticisidir. Sonrasında etkileşime girenler farklı nitelenir.
        owner = msg.sender; //Bu şekilde deploy eden kişi direkt yönetici tag'ini alır.
    }
    

    function createOrder(string memory _zipCode, uint256[] memory _products) external returns(uint256){
        require(_products.length > 0 , "No products. Please add product.");
        
        //Order'ı oluşturmak için ürün kontrolü.
        Order memory order; //Veri depolamayı arrayde yapıcaz. Fonksiyon localinde bir geçiçi bir kopya oluşturmak için memory kullandık.
        order.customer = msg.sender; //Foksiyon bittiken kopya yok olur. alttaki push ykomutu ile state variable'a atarız ve depolanmış olur.
        order.zipCode = _zipCode;
        order.products = _products;
        order.status = Status.Taken;

        orders.push(order); //Order'ımızı orders arryine kayıt ettik.
        
        //orders.push(Order({...})); şeklinde yazımı:
        /*
        orders.push(Order({  
            customer:msg.sender,
            zipCode:_zipCode,
            products:_products,
            status:Status.Taken
        }));
        */

        //orders.push(Order(...)); Bu yazım en sade halidir. Size göre en uygun olanı kullanınız.
        /*
        orders.push(Order(msg.sender,_zipCode,_products,Status.Taken));
        */

        return orders.length - 1; // indexi vermesi için döndürme işlemi yaptık.
    }

    function changeStatus(uint256 _orderID) external {
        require(owner == msg.sender,"You are not authorized."); //Bu fonskiyonu sadece owner kullanabilir.
        require(_orderID < orders.length, "Not a valid order id."); // Geçerli bir oderID verilmesi lazım.

        Order storage order =  orders[_orderID] ; //Depolanmış veride değişiklik yapacaz / Storage
        require(order.status != Status.Shipped, "Order is already shipped."); //Zaten yoldaysa durumu değişimine gerek yok.
        
        if(order.status == Status.Taken) order.status = Status.Preparing; //Durumları değiştirme.
        else if(order.status == Status.Preparing) order.status = Status.Boxed;
        else if(order.status == Status.Boxed) order.status = Status.Shipped;
       
    }

    function getOrder(uint256 _orderID) external view returns(Order memory) {
        require(_orderID<orders.length,"Not a valid order id."); // geçerli order ıd
        
        return orders[_orderID];
    }

    function updateZip(uint256 _orderID,string memory _zipCode) external {
        
        require(_orderID < orders.length, "Not a valid order id."); // Geçerli bir oderID verilmesi lazım.
        Order storage order = orders[_orderID];
        require(order.customer == msg.sender,"You are not the owner of the order");
        order.zipCode = _zipCode;
        //orders[_orderID].zipCode = _zipCode; şeklindede yazabilirdik.

    }





}