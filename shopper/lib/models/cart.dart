import 'package:shopper/models/Product.dart';

class Cart {
  final Product product;
  int numOfItem;

  Cart({required this.product, required this.numOfItem});

  static double totalPrice(List<Cart> cartList) {
    double total = 0;
    for (var element in cartList) {
      total += element.product.price * element.numOfItem;
    }
    return total;
  }

  static int totalItem(List<Cart> cartList) {
    int total = 0;
    for (var element in cartList) {
      total += element.numOfItem;
    }
    return total;
  }
}
