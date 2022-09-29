// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract Modifier { 
    //Struct çalışma alanı üzerinden modifier anlatımı.
    //Bir fonksiyonun çalışmasından sonra veya önce, belirdiğimiz özellikleri katmak istiyorsak modifier kullanılır.
    //Mesela bir komutu birden fazla fonksiyondan önce veya sonra kullanıyorsak, modifier ile komutu standartlaştırmış oluyoruz.
    //Bu şekilde okunurluk artıyor, okuyucular için güvenirlik sağlıyor, kod yazımında kolaylık sağlıyor.
    //Modifier'lar genelde kodun sonuna yazılır. 

    enum Status {
        Taken,
        Preparing,
        Boxed,
        Shipped
    }

    struct Order {
        address customer;
        string zipCode;
        uint256[] products;
        Status status;
    }

    Order[] public orders;
    address public owner;
    uint256 public txCount; //transaction counter, müşteriler bir fonksiyonu kaç kere okumuş.
    //Normalde bu veri gereksiz alan tutmamıza neden olur, direkt etherScan veya blockchain'imizden veri okuyarak transaction count'a ulaşabilirdik.

    constructor() {
        owner = msg.sender;
    }

    //checkProducts modifier'ı ile içerideki require komutunu standart haline getirdik.
    //Ve bu standart başka fonksiyonlarda kullanılacaksa aynı şekilde checkProducts modifier'ı kullanabiliriz.
    //incTx ile transaction counter'ımızı arttırarak sayım yaptık.
    function createOrder(string memory _zipCode, uint256[] memory _products) checkProducts(_products) incTx external returns(uint256) {
        // require(_products.length > 0, "No products.");

        Order memory order;
        order.customer = msg.sender;
        order.zipCode = _zipCode;
        order.products = _products;
        order.status = Status.Taken;
        orders.push(order);
        
        return orders.length - 1;
    }
    //checkOrderID, onlyOwner ile içerideki require komutlarını standart yaptık.
    function advanceOrder(uint256 _orderID) checkOrderID(_orderID) onlyOwner external {
        // require(owner == msg.sender, "You are not authorized.");
        // require(_orderID < orders.length, "Not a valid order id.");

        Order storage order = orders[_orderID];
        require(order.status != Status.Shipped, "Order is already shipped.");

        if (order.status == Status.Taken) {
            order.status = Status.Preparing;
        } else if (order.status == Status.Preparing) {
            order.status = Status.Boxed;
        } else if (order.status == Status.Boxed) {
            order.status = Status.Shipped;
        }
    }
    
    //checkOrderID ile içerideki require komutunu standart yaptık.
    function getOrder(uint256 _orderID) checkOrderID(_orderID) external view returns (Order memory) {
        // require(_orderId < orders.length, "Not a valid order id.");
    
        return orders[_orderID];
    }
    
    //checkOrderID, onlyCustomer, incTx ile içerideki require komutlarını standart yaptık.
    //incTx ile transaction counter'ımızı arttırarak sayım yaptık.
    function updateZip(uint256 _orderID, string memory _zip) checkOrderID(_orderID) onlyCustomer(_orderID) incTx external {
        // require(_orderId < orders.length, "Not a valid order id.");
        Order storage order = orders[_orderID];
        // require(order.customer == msg.sender, "You are not the owner of the order.");
        order.zipCode = _zip;
        //orders[_orderID].zipCode = _zipCode; şeklindede yazabilirdik.
    }

    modifier checkProducts(uint256[] memory _products){
        require(_products.length > 0, "No products.");
        _; //_; ifadesi fonksiyon başlatıldığında mı çalışşın ? Yoksa fonksiyon bittikten sonra mı çalışsın ? Sorusunu temsil eder.
    }
    //eğer _; modifier'ın ilk komutu olsaydı fonksiyon bitince modifier içindeki komutları çalıştır anlamına gelirdi.
    //Aşağıda txCount modifier'ında bu şekilde kullandık. Çünkü transaction bittikten sonra txCount artmalı.
    modifier  checkOrderID(uint256  _orderID){
        require(_orderID < orders.length, "Not a valid order id.");
        _;
    }
    modifier incTx{ //sadece customer fonksiyonlarına eklemek için incTx oluşturduk.
        _;
        txCount +=1;
    }
    modifier onlyOwner{
        require(owner == msg.sender, "You are not authorized.");
        _;
    }
    modifier onlyCustomer(uint256  _orderID){
        require(orders[_orderID].customer == msg.sender, "You are not the owner of the order.");
        _;
    }

}