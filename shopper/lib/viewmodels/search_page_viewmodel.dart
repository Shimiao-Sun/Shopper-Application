import 'package:flutter/material.dart';
import '../models/DBService.dart';
import '../models/Product.dart';

class SearchViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<Product> products = [];
  String searchString = "";

  updateProduct(String inputString) async {
    searchString = inputString;
    products = await _dbService.fetchProductsByMatchName(searchString);
  }
}
