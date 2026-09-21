import 'package:shopper/models/Product.dart';

class Order {
  int orderID;
  late String orderStatus;
  late int price;
  String sellerName;
  late int itemNum;
  late List<Product> products;
  late String streetAddress;
  late String suburb;
  late String state;
  late String country;
  late int postcode;

  Order({required this.orderID, required this.sellerName});

  List<Product> getOrderProducts() {
    return products;
  }

  setOrderStatus(int orderStatusDB) {
    if (orderStatusDB == 0) {
      orderStatus = "Placed";
    }
  }
}
