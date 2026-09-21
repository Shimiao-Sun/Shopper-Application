import 'package:flutter/material.dart';
import 'package:shopper/models/ShippingDetails.dart';
import '../models/cart.dart';
import '../models/DBService.dart';
import '../models/account.dart';

class CheckoutViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();

  Future<bool> saveOrderDetails(List<Cart> orderedCart, int? buyerId,
      ShippingDetails shippingDetails) async {
    return await _dbService.saveOrderDetails(
        orderedCart, buyerId, shippingDetails);
  }

  Future<int> getUserId(Account user) async {
    var userDetails = await _dbService.getUserInfo(user.email);
    return userDetails[0][0];
  }
}
