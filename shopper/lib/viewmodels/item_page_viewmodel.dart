import 'package:flutter/material.dart';
import 'package:shopper/models/DBService.dart';

import '../models/Product.dart';

class ItemViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();

  Future<Product> getItemDetails(int itemId) async {
    return await _dbService.fetchProductById(itemId);
  }
}
