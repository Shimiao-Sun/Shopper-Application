import 'package:flutter/material.dart';
import 'package:shopper/models/cart.dart';
import 'package:shopper/models/DBService.dart';
import 'package:shopper/models/Product.dart';
import 'package:shopper/models/account.dart';

class CartViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<Cart> carts = [];

  int checkItemInCart(Product product) {
    int count = 0;
    for (var cart in carts) {
      if (cart.product.id == product.id) {
        return count;
      }
      count++;
    }
    return -1;
  }

  updateCartItemQuantity(int cartItemID) async {
    //Check if no user is login
    if (Account.user.userID == 0) {
      return;
    }
    await _dbService.updateCartQuantity(carts[cartItemID].product.id,
        Account.user.userID, carts[cartItemID].numOfItem);
  }

  getUserCart(int userID) async {
    List<Product> resultProduct = [];

    int length = carts.length;

    List<List> results = await _dbService.getCartInfo(userID);
    for (var item in results) {
      List<List> resultsItem = await _dbService.getProductInfo(item[1]);
      for (var row in resultsItem) {
        Product product = Product(
            title: row[1],
            id: row[0],
            sellerId: row[8],
            sellerName: row[2],
            price: row[3],
            image: row[4],
            description: row[5],
            quantity: row[6],
            category: row[7]);

        resultProduct.add(product);
        // check if exist
        int check = checkItemInCart(product);
        if (check == -1) {
          carts.add(Cart(product: product, numOfItem: item[2]));
        } else {
          if (carts[check].numOfItem < item[2]) {
            carts[check].numOfItem = item[2];
          } else if (carts[check].numOfItem > item[2]) {
            await updateCartItemQuantity(check);
          }
        }
      }
    }

    // Update local cart to database
    for (var i = 0; i < length; i++) {
      int check = 0;

      for (var item in resultProduct) {
        if (item.id == carts[i].product.id) {
          check = 1;
          break;
        }
      }

      if (check == 0) {
        await _dbService.addCartItem(
            carts[i].product.id, userID, carts[i].numOfItem);
      }
    }
  }

  removeItemFromCart(Product product) async {
    int index = checkItemInCart(product);
    if (index != -1) {
      carts.removeAt(index);

      if (Account.user.userID != 0) {
        await _dbService.removeCartItem(product.id, Account.user.userID);
      }
    }
  }

  addItemToCart(Product product, int quantity) async {
    if (Account.user.userID == 0) {
      carts.add(Cart(product: product, numOfItem: quantity));
      return;
    }

    carts.add(Cart(product: product, numOfItem: quantity));
    await _dbService.addCartItem(product.id, Account.user.userID, quantity);
  }

  clearCart() async {
    carts.clear();
    if (Account.user.userID != 0) {
      await _dbService.clearCart(Account.user.userID);
    }
  }
}
