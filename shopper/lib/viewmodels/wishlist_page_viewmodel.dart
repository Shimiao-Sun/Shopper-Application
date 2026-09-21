import 'package:flutter/material.dart';
import 'package:shopper/models/DBService.dart';
import 'package:shopper/models/Product.dart';
import 'package:shopper/models/account.dart';

import '../models/Wishlist.dart';

class WishlistViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<Wishlist> wishlists = [];

  int checkItemInWishlist(Product product) {
    int count = 0;
    for (var item in wishlists) {
      if (item.product.id == product.id) {
        return count;
      }
      count++;
    }
    return -1;
  }

  getUserWishlist(int userID) async {
    List<Product> resultProduct = [];

    int length = wishlists.length;

    List<List> results = await _dbService.getWishlistInfo(userID);
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

        // check if item is in wishlist
        int check = checkItemInWishlist(product);
        if (check == -1) {
          wishlists.add(Wishlist(product: product));
        }
      }
    }

    // Update local wishlist to database
    for (var i = 0; i < length; i++) {
      int check = 0;

      for (var item in resultProduct) {
        if (item.id == wishlists[i].product.id) {
          check = 1;
          break;
        }
      }

      if (check == 0) {
        await _dbService.addWishlistItem(wishlists[i].product.id, userID);
      }
    }
  }

  addItemToWishlist(Product product) async {
    if (Account.user.userID == 0) {
      wishlists.add(Wishlist(product: product));
      return;
    }

    wishlists.add(Wishlist(product: product));
    await _dbService.addWishlistItem(product.id, Account.user.userID);
  }

  removeItemToWishlist(Product product) {
    int index = checkItemInWishlist(product);

    if (index != -1) {
      wishlists.removeAt(index);
    }
  }

  removeItemFromWishlist(Product product) async {
    if (Account.user.userID == 0) {
      return;
    }

    await _dbService.removeWishlistItem(product.id, Account.user.userID);
  }

  clearWishlist() async {
    wishlists.clear();
    if (Account.user.userID != 0) {
      await _dbService.clearWishlist(Account.user.userID);
    }
  }
}
