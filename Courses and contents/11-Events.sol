// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;


//Event'ler akıllı kontratlarda çok kullanılmaz.
//Ama dAPP geliştirmelerinde önemli bir yeri vardır.
//Akıllı sözleşmelerin sonucunu, bazı fonksiyonalrın tamamlandığını, dışarı çıkmasını istediğimiz bilgileri
//events'ler sayesinde takip edebiliyoruz. Bu yüzden dApp'ler için önemlidir.

//Mesela uniswap üzerinden ETH <=> WrappedETH 'ye takas/swap işlemi yaparsak.
// bize "pending/bekliyor" uyarısı verir.
//Bu uyarı aslında kullandığımız akıllı kontratı bekliyor, peki bu dApps uygulaması bittiğinde bilgiyi nereden alacak?
//İşte burada akıllı kontratın içinde bulunan events'den bir cevap beklediğini söyleyebiliriz.
//dApps uygulaması, event'den cevap aldıktann sonra bize işlemin durumu hakkında bilgi verecektir.

contract Events {
      // Event declaration
     // Up to 3 parameters can be indexed.
    // Indexed parameters helps you filter the logs by the indexed parameter
    event Message ( address indexed from , address indexed to , string message ) ;
    
    function sendMessage ( address _to , string calldata message ) external {
        emit Message ( msg.sender , _to , message ) ;
    }

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
    uint256 public txCount;
    //----------------------++++++++++++++++++++++++++++++++++++++++++
    event OrderCreated(uint256 _orderId, address indexed _consumer);
    //indexed ile bir değişken declare edilirse,
    //o değişken ile ilgili sorguları, blockchain üzerinden yapabilir hale geliriz.
    event ZipChanged(uint256 _orderId, string _zipCode);
    //createOrder ve updateZip blockchain üzerinde çalışınca, event'lere bilgiler girilmiş olur, 
    //artık bu eventleri çağırarak blockchain üzerinden bigilere ulaşılabilir.
    //Buradan event ile saklanan bilgilerin, blockchain üzerinde depolandığını söyleyebiliriz.
    //----------------------++++++++++++++++++++++++++++++++++++++++++
    constructor() {
        owner = msg.sender;
    }

    function createOrder(string memory _zipCode, uint256[] memory _products) checkProducts(_products) incTx external returns(uint256) {
        Order memory order;
        order.customer = msg.sender;
        order.zipCode = _zipCode;
        order.products = _products;
        order.status = Status.Taken;
        orders.push(order);
        //----------------------++++++++++++++++++++++++++++++++++++++++++
        emit OrderCreated(orders.length - 1, msg.sender); //Emit ile event'e bilgileri girdik.
        //----------------------++++++++++++++++++++++++++++++++++++++++++
        return orders.length - 1;
    }

    function advanceOrder(uint256 _orderId) checkOrderId(_orderId) onlyOwner external {
        Order storage order = orders[_orderId];
        require(order.status != Status.Shipped, "Order is already shipped.");

        if (order.status == Status.Taken) {
            order.status = Status.Preparing;
        } else if (order.status == Status.Preparing) {
            order.status = Status.Boxed;
        } else if (order.status == Status.Boxed) {
            order.status = Status.Shipped;
        }
    }

    function getOrder(uint256 _orderId) checkOrderId(_orderId) external view returns (Order memory) {
        return orders[_orderId];
    }

    function updateZip(uint256 _orderId, string memory _zip) checkOrderId(_orderId) onlyCustomer(_orderId) incTx external {
        Order storage order = orders[_orderId];
        order.zipCode = _zip;
        //----------------------++++++++++++++++++++++++++++++++++++++++++
        emit ZipChanged(_orderId, _zip);//Emit ile event'e bilgileri girdik.
        //----------------------++++++++++++++++++++++++++++++++++++++++++
    }

    modifier checkProducts(uint256[] memory _products) {
        require(_products.length > 0, "No products.");
        _;
    }

    modifier checkOrderId(uint256 _orderId) {
        require(_orderId < orders.length, "Not a valid order id.");
        _;
    }

    modifier incTx {
        _;
        txCount++;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "You are not authorized.");
        _;
    }

    modifier onlyCustomer(uint256 _orderId) {
        require(orders[_orderId].customer == msg.sender, "You are not the owner of the order.");
        _;
    }

}