// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'Product.dart';
import 'category.dart';
import 'package:collection/collection.dart';
import 'package:shopper/models/ShippingDetails.dart';
import 'cart.dart';
import 'package:postgres/postgres.dart';
import 'order.dart';

class DBService {
  var databaseConnection;

  void sqlInit() {
    databaseConnection = PostgreSQLConnection(
        "database-1.cywhmv98ew17.ap-southeast-2.rds.amazonaws.com",
        5432,
        "shopper",
        queryTimeoutInSeconds: 3600,
        timeoutInSeconds: 3600,
        username: "postgres",
        password: "admin8888");
  }

  Future<List<Category>> fetchCategory() async {
    sqlInit();
    await databaseConnection.open();
    List<Category> categories = [];
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT image_path, category_name,category_id FROM shopper.Category");
    for (final row in results) {
      categories.add(Category(title: row[1], image: row[0], id: row[2]));
    }
    databaseConnection.close();
    return categories;
  }

  Future<List<Product>> fetchProductByCategory(int categoryId) async {
    sqlInit();
    await databaseConnection.open();
    List<Product> products = [];
    List<List<dynamic>> results = await databaseConnection.query(
        "select item.item_id, product_name, useraccount.first_name, price , item.image_path, description, quantity, category_name, Item.seller_id from shopper.item join shopper.itemcategory on shopper.item.item_id=shopper.itemcategory.item_id join shopper.category on shopper.category.category_id=shopper.itemcategory.category_id join shopper.useraccount on shopper.item.seller_id=shopper.useraccount.user_id where category.category_id = @catValue",
        substitutionValues: {"catValue": "$categoryId"});

    for (final row in results) {
      products.add(Product(
          title: row[1],
          id: row[0],
          sellerId: row[8],
          sellerName: row[2],
          price: row[3],
          image: row[4],
          description: row[5],
          quantity: row[6],
          category: row[7]));
    }
    databaseConnection.close();
    return products;
  }

  Future<List<Product>> fetchProductsByMatchName(String name) async {
    sqlInit();
    await databaseConnection.open();
    List<Product> products = [];
    List<List<dynamic>> results = await databaseConnection.query(
        "select item.item_id, product_name,useraccount.first_name, price , item.image_path, description, quantity, category_name,item.seller_id from shopper.item join shopper.itemcategory on shopper.item.item_id = shopper.itemcategory.item_id join shopper.category on shopper.category.category_id = shopper.itemcategory.category_id join shopper.useraccount on shopper.item.seller_id=shopper.useraccount.user_id where lower(shopper.item.product_name) Like @name",
        substitutionValues: {"name": "%${name.toLowerCase()}%"});

    for (final row in results) {
      products.add(Product(
          title: row[1],
          id: row[0],
          sellerId: row[8],
          sellerName: row[2],
          price: row[3],
          image: row[4],
          description: row[5],
          quantity: row[6],
          category: row[7]));
    }
    databaseConnection.close();
    return products;
  }

  Future<Product> fetchProductById(int productId) async {
    sqlInit();
    await databaseConnection.open();

    List<List<dynamic>> results = await databaseConnection.query(
        "select item.item_id, product_name,useraccount.first_name, price , item.image_path, description, quantity, category_name,item.seller_id from shopper.item join shopper.itemcategory on shopper.item.item_id = shopper.itemcategory.item_id join shopper.category on shopper.category.category_id = shopper.itemcategory.category_id join shopper.useraccount on shopper.item.seller_id=shopper.useraccount.user_id where shopper.item.item_id = @itemId",
        substitutionValues: {"itemId": productId});

    List<dynamic> productDetails = results[0];
    Product product = Product(
        title: productDetails[1],
        id: productDetails[0],
        sellerId: productDetails[8],
        sellerName: productDetails[2],
        price: productDetails[3],
        image: productDetails[4],
        description: productDetails[5],
        quantity: productDetails[6],
        category: productDetails[7]);

    return product;
  }

  Future<String> fetchCategoryNameById(int categoryId) async {
    sqlInit();
    await databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
        "select category_name from shopper.category where category.category_id = @catValue",
        substitutionValues: {"catValue": "$categoryId"});
    databaseConnection.close();
    return results[0][0];
  }

  Future<List<List>> getUserInfo(String email) async {
    sqlInit();
    await databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
        "select * from shopper.UserAccount where UserAccount.email = @account and user_type = 2",
        substitutionValues: {"account": email});
    databaseConnection.close();

    return results;
  }

  Future<bool> saveUserInfo(String email, String password, String firstName,
      String lastName, String salt) async {
    sqlInit();
    await databaseConnection.open();

    // Check if user exist
    List<List<dynamic>> results = await databaseConnection.query(
        "select * from shopper.UserAccount where UserAccount.email = @account",
        substitutionValues: {"account": email});

    if (results.isNotEmpty) {
      return false;
    }

    await databaseConnection.query(
        "INSERT INTO shopper.UserAccount (first_name,last_name,email,hashed_pw,salt,user_type) VALUES (@first_name,@last_name,@email,@hashed_pw,@salt,@user_type)",
        substitutionValues: {
          "email": email,
          "hashed_pw": password,
          "first_name": firstName,
          "last_name": lastName,
          "salt": salt,
          "user_type": 2
        });
    databaseConnection.close();
    return true;
  }

  Future<bool> resetUserPassword(String email, String password) async {
    sqlInit();
    await databaseConnection.open();

    // Check if user exists
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT UserAccount.user_id FROM shopper.UserAccount WHERE UserAccount.email = @account",
        substitutionValues: {"account": email});

    if (results.isEmpty) {
      return false;
    }

    await databaseConnection.query(
        "UPDATE shopper.UserAccount SET hashed_pw = @hashed_pw WHERE UserAccount.email = @account",
        substitutionValues: {"hashed_pw": password, "account": email});

    databaseConnection.close();
    return true;
  }

  Future<List<List>> getResetCode(int code) async {
    sqlInit();
    await databaseConnection.open();

    return await databaseConnection.query(
        "SELECT * FROM shopper.VerificationCode WHERE VerificationCode.code = @code",
        substitutionValues: {"code": code});
  }

  Future<bool> setCodeUsed(int code) async {
    sqlInit();
    await databaseConnection.open();

    await databaseConnection.query(
        "UPDATE shopper.VerificationCode SET is_used = 1 WHERE VerificationCode.code = @code",
        substitutionValues: {"code": code});

    return true;
  }

  Future<bool> storeResetCode(String email, int code, String dateTime) async {
    sqlInit();
    await databaseConnection.open();

    // Get UserId
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT UserAccount.user_id FROM shopper.UserAccount WHERE UserAccount.email = @account",
        substitutionValues: {"account": email});

    if (results.isEmpty) {
      return false;
    }

    int userId = results[0][0];

    // Store code in DB
    await databaseConnection.query(
        "INSERT INTO shopper.VerificationCode (user_id,code,date_time,is_used) VALUES (@user_id,@code,@date_time,@is_used)",
        substitutionValues: {
          "user_id": userId,
          "code": code,
          "date_time": dateTime,
          "is_used": 0
        });

    return true;
  }

  Future<String> getApiKey(String api) async {
    sqlInit();
    await databaseConnection.open();

    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT ApiKey.apikey FROM shopper.ApiKey WHERE ApiKey.api = @api",
        substitutionValues: {"api": api});

    if (results.isEmpty) {
      return "";
    }

    return results[0][0];
  }

  Future<List<List>> getCartInfo(int userID) async {
    sqlInit();
    await databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
        "select * from shopper.Cart where Cart.user_id = @userID",
        substitutionValues: {"userID": userID});
    databaseConnection.close();
    return results;
  }

  Future<List<List>> getProductInfo(int itemID) async {
    sqlInit();
    await databaseConnection.open();

    List<List<dynamic>> results = await databaseConnection.query(
        "select item.item_id, product_name, useraccount.first_name, price , item.image_path, description, quantity, category_name, Item.seller_id from shopper.item join shopper.itemcategory on shopper.item.item_id=shopper.itemcategory.item_id join shopper.category on shopper.category.category_id=shopper.itemcategory.category_id join shopper.useraccount on shopper.item.seller_id=shopper.useraccount.user_id where Item.item_id = @itemID",
        substitutionValues: {"itemID": itemID});
    databaseConnection.close();
    return results;
  }

  Future<void> updateCartQuantity(int itemID, int userID, int quantity) async {
    sqlInit();
    await databaseConnection.open();

    await databaseConnection.query(
        "UPDATE shopper.Cart SET quantity = @quantity WHERE Cart.item_id = @itemID and Cart.user_id = @userID",
        substitutionValues: {
          "quantity": quantity,
          "itemID": itemID,
          "userID": userID
        });
    databaseConnection.close();
  }

  Future<void> addCartItem(int itemID, int userID, int quantity) async {
    sqlInit();
    await databaseConnection.open();
    await databaseConnection.query(
        "INSERT INTO shopper.Cart (user_id,item_id,quantity) VALUES (@userID,@itemID,@quantity)",
        substitutionValues: {
          "quantity": quantity,
          "itemID": itemID,
          "userID": userID
        });
    databaseConnection.close();
  }

  Future<void> removeCartItem(int itemID, int userID) async {
    sqlInit();
    await databaseConnection.open();
    await databaseConnection.query(
        "DELETE FROM shopper.Cart WHERE Cart.user_id=@userID and Cart.item_id=@itemID",
        substitutionValues: {"itemID": itemID, "userID": userID});
    databaseConnection.close();
  }

  Future<void> clearCart(int userID) async {
    sqlInit();
    await databaseConnection.open();
    await databaseConnection.query(
        "DELETE FROM shopper.Cart WHERE Cart.user_id=@userID",
        substitutionValues: {"userID": userID});
    databaseConnection.close();
  }

  Future<bool> saveOrderDetails(List<Cart> orderedCart, int? buyerId,
      ShippingDetails shippingDetails) async {
    if (orderedCart.isEmpty) {
      return false;
    } else if (shippingDetails.initialised == false) {
      return false;
    }

    sqlInit();
    await databaseConnection.open();

    // Check if address exists
    int addressId = await findExistingAddressId(shippingDetails);

    // If address doesn't exist, insert a new row into the table
    if (addressId == -1) {
      await databaseConnection.query(
          "INSERT INTO shopper.Address (street_address,suburb,state,postcode,country) VALUES (@street_address,@suburb,@state,@postcode,@country)",
          substitutionValues: {
            "street_address": shippingDetails.streetAddress,
            "suburb": shippingDetails.suburb,
            "state": shippingDetails.state,
            "postcode": shippingDetails.postcode,
            "country": shippingDetails.country
          });
      // Obtain newly inserted Address ID
      addressId = await findExistingAddressId(shippingDetails);
    }

    // Group Items by Seller Id
    var sellerGroups = groupBy(orderedCart, (Cart c) {
      return c.product.sellerId;
    });

    // Insert new UserOrders into the DB
    var sellerIds = sellerGroups.keys;
    for (var id in sellerIds) {
      await databaseConnection.query(
          "INSERT INTO shopper.UserOrder (seller_id,buyer_id,order_status,address_id) VALUES (@seller_id,@buyer_id,@order_status,@address_id)",
          substitutionValues: {
            "seller_id": id,
            "buyer_id": buyerId,
            "order_status": 0, // Orders always start with status 0
            "address_id": addressId
          });
    }

    // Obtain newly inserted Order IDs. Create mapping between Seller ID and the corresponding Order Ids
    Map<int, int> newUserOrders = {};
    for (var id in sellerIds) {
      int orderId = await findUserOrderId(id, buyerId, 0, addressId);
      if (orderId == -1) {
        return false;
      }
      newUserOrders.putIfAbsent(id, () => orderId);
    }

    // Insert Items in order into OrderItem Table
    for (var c in orderedCart) {
      await databaseConnection.query(
          "INSERT INTO shopper.OrderItem (order_id,item_id,quantity) VALUES (@order_id,@item_id,@quantity)",
          substitutionValues: {
            "order_id": newUserOrders[c.product.sellerId],
            "item_id": c.product.id,
            "quantity": c.numOfItem
          });
    }

    databaseConnection.close();
    return true;
  }

  Future<int> findExistingAddressId(ShippingDetails shippingDetails) async {
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT Address.address_id FROM shopper.Address WHERE Address.street_address = @street_address AND Address.suburb = @suburb AND Address.state = @state AND Address.postcode = @postcode AND Address.country = @country",
        substitutionValues: {
          "street_address": shippingDetails.streetAddress,
          "suburb": shippingDetails.suburb,
          "state": shippingDetails.state,
          "postcode": shippingDetails.postcode,
          "country": shippingDetails.country
        });
    if (results.isEmpty) {
      return -1;
    }
    return results[0][0];
  }

  Future<int> findUserOrderId(
      int sellerId, int? buyerId, int orderStatus, int addressId) async {
    // Search just based on sellerId first
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT UserOrder.order_id FROM shopper.UserOrder WHERE UserOrder.seller_id = @seller_id",
        substitutionValues: {"seller_id": sellerId});
    if (results.isEmpty) {
      return -1;
    } else if (results.length == 1) {
      return results[0][0];
    }

    // Otherwise, there are more than one entries for this seller ID. Will have to see if we can match by more than just seller_id
    if (buyerId == null) {
      results = await databaseConnection.query(
          "SELECT UserOrder.order_id FROM shopper.UserOrder WHERE UserOrder.seller_id = @seller_id AND UserOrder.buyer_id IS NULL AND UserOrder.order_status = @order_status AND UserOrder.address_id = @address_id",
          substitutionValues: {
            "seller_id": sellerId,
            "buyer_id": buyerId,
            "order_status": orderStatus,
            "address_id": addressId
          });
    } else {
      results = await databaseConnection.query(
          "SELECT UserOrder.order_id FROM shopper.UserOrder WHERE UserOrder.seller_id = @seller_id AND UserOrder.buyer_id = @buyer_id AND UserOrder.order_status = @order_status AND UserOrder.address_id = @address_id",
          substitutionValues: {
            "seller_id": sellerId,
            "buyer_id": buyerId,
            "order_status": orderStatus,
            "address_id": addressId
          });
    }

    if (results.length == 1) {
      return results[0][0];
    }

    // Still more than one entry, therefore, we return the highest Order ID out of the list
    List<int> list = [];
    for (var r in results) {
      list.add(r[0]);
    }

    return list.max;
  }

  // Wishlist functions
  Future<List<List>> getWishlistInfo(int userID) async {
    sqlInit();
    await databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT * from shopper.Wishlist WHERE Wishlist.user_id = @userID",
        substitutionValues: {"userID": userID});
    databaseConnection.close();
    return results;
  }

  Future<List<List>> getUserOrders(int userID) async {
    sqlInit();
    await databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT Userorder.order_id, useraccount.first_name, Userorder.order_status, Userorder.address_id FROM shopper.userorder join shopper.useraccount on seller_id=user_id where UserOrder.buyer_id = @userID",
        substitutionValues: {"userID": userID});
    databaseConnection.close();
    return results;
  }

  Future<void> addWishlistItem(int itemID, int userID) async {
    sqlInit();
    await databaseConnection.open();
    await databaseConnection.query(
        "INSERT INTO shopper.Wishlist (user_id,item_id) VALUES (@userID,@itemID)",
        substitutionValues: {"itemID": itemID, "userID": userID});
    databaseConnection.close();
  }

  Future<void> removeWishlistItem(int itemID, int userID) async {
    sqlInit();
    await databaseConnection.open();
    await databaseConnection.query(
        "DELETE FROM shopper.Wishlist WHERE Wishlist.user_id=@userID and Wishlist.item_id=@itemID",
        substitutionValues: {"itemID": itemID, "userID": userID});
    databaseConnection.close();
  }

  Future<void> clearWishlist(int userID) async {
    sqlInit();
    await databaseConnection.open();
    await databaseConnection.query(
        "DELETE FROM shopper.Wishlist WHERE Wishlist.user_id=@userID",
        substitutionValues: {"userID": userID});
    databaseConnection.close();
  }

  Future<List<List>> getUserOrderItems(int orderID) async {
    sqlInit();
    await databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT OrderItem.item_id, OrderItem.quantity FROM shopper.userorder join shopper.OrderItem on userorder.order_id=OrderItem.order_id where userorder.order_id  = @orderID",
        substitutionValues: {"orderID": orderID});
    databaseConnection.close();
    return results;
  }

  Future<List<List>> getUserOrderAddress(int addressID) async {
    sqlInit();
    await databaseConnection.open();
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT * FROM shopper.Address where Address.address_id  = @addressID",
        substitutionValues: {"addressID": addressID});
    databaseConnection.close();
    return results;
  }

  Future<List<Order>> getOrderList(int userID) async {
    sqlInit();
    await databaseConnection.open();
    List<Order> orderList = [];
    List<List<dynamic>> results = await databaseConnection.query(
        "SELECT Userorder.order_id, useraccount.first_name, Userorder.order_status, Userorder.address_id FROM shopper.userorder join shopper.useraccount on seller_id=user_id where UserOrder.buyer_id = @userID",
        substitutionValues: {"userID": userID});

    for (var row in results) {
      Order temp = Order(orderID: row[0], sellerName: row[1]);
      temp.itemNum = 0;
      temp.products = [];
      temp.price = 0;

      List<List<dynamic>> resultsItem = await databaseConnection.query(
          "SELECT OrderItem.item_id, OrderItem.quantity FROM shopper.userorder join shopper.OrderItem on userorder.order_id=OrderItem.order_id where userorder.order_id  = @orderID",
          substitutionValues: {"orderID": row[0]});

      for (var item in resultsItem) {
        List<List<dynamic>> resultsProduct = await databaseConnection.query(
            "select item.item_id, product_name, useraccount.first_name, price , item.image_path, description, quantity, category_name, Item.seller_id from shopper.item join shopper.itemcategory on shopper.item.item_id=shopper.itemcategory.item_id join shopper.category on shopper.category.category_id=shopper.itemcategory.category_id join shopper.useraccount on shopper.item.seller_id=shopper.useraccount.user_id where Item.item_id = @itemID",
            substitutionValues: {"itemID": item[0]});
        Product product = Product(
            title: resultsProduct[0][1],
            id: resultsProduct[0][0],
            sellerId: resultsProduct[0][8],
            sellerName: resultsProduct[0][2],
            price: resultsProduct[0][3],
            image: resultsProduct[0][4],
            description: resultsProduct[0][5],
            quantity: item[1],
            category: resultsProduct[0][7]);
        temp.products.add(product);
        int num = item[1];
        temp.itemNum += num;
        num = resultsProduct[0][3] * num;
        temp.price += num;
      }
      temp.setOrderStatus(row[2]);

      // Setup order address
      List<List<dynamic>> resultAddress = await databaseConnection.query(
          "SELECT * FROM shopper.Address where Address.address_id  = @addressID",
          substitutionValues: {"addressID": row[3]});
      temp.streetAddress = resultAddress[0][1];
      temp.suburb = resultAddress[0][2];
      temp.state = resultAddress[0][3];
      temp.postcode = resultAddress[0][4];
      temp.country = resultAddress[0][5];

      orderList.add(temp);
    }

    databaseConnection.close();

    return orderList;
  }

  Future<void> updateFirstName(String firstName, int userID) async {
    sqlInit();
    await databaseConnection.open();
    await databaseConnection.query(
        "UPDATE shopper.UserAccount SET first_name = @firstName where UserAccount.user_id = @userID",
        substitutionValues: {"firstName": firstName, "userID": userID});

    databaseConnection.close();
  }

  Future<void> updateLastName(String lastName, int userID) async {
    sqlInit();
    await databaseConnection.open();
    await databaseConnection.query(
        "UPDATE shopper.UserAccount SET last_name = @lastName where UserAccount.user_id = @userID",
        substitutionValues: {"lastName": lastName, "userID": userID});

    databaseConnection.close();
  }

  Future<void> deleteAccount(int userID) async {
    sqlInit();
    await databaseConnection.open();

    // set this all the order's buyer id to null
    await databaseConnection.query(
        "UPDATE shopper.UserAccount SET first_name = 'Deleted Account', last_name = '', email = '', hashed_pw='',salt='' where UserAccount.user_id = @userID",
        substitutionValues: {"userID": userID});

    databaseConnection.close();
  }
}
