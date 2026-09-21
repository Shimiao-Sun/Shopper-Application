import 'package:flutter/material.dart';
import 'package:shopper/models/DBService.dart';
import 'package:shopper/models/account.dart';
import 'package:shopper/models/order.dart';

class AccountViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<Order> order = [];

  Future<int> getOrders(int userID) async {
    order = await _dbService.getOrderList(Account.user.userID);

    return 1;
  }

  Future<List<int>> editProfile(String newFirstName, String newLastName) async {
    List<int> checklist = [0, 0];
    // Check if need update each section
    if (newFirstName != "" && newFirstName != Account.user.firstName) {
      await _dbService.updateFirstName(newFirstName, Account.user.userID);
      Account.user.firstName = newFirstName;
      checklist[0] = 1;
    }

    if (newLastName != "" && newLastName != Account.user.lastName) {
      await _dbService.updateLastName(newLastName, Account.user.userID);
      Account.user.lastName = newLastName;
      checklist[1] = 1;
    }

    return checklist;
  }

  deleteAccount() async {
    // Clear the cart and wishlist
    await _dbService.clearCart(Account.user.userID);
    await _dbService.clearWishlist(Account.user.userID);

    // Clear user info
    await _dbService.deleteAccount(Account.user.userID);
  }

  clearOrder() {
    order.clear();
  }
}
