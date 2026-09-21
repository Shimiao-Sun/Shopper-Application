// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import '../models/DBService.dart';
import '../models/Product.dart';
import '../models/category.dart';

class CategoryViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<Product> _products = [];
  List<Product> get products => _products;
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  String _category_name = "";
  String get category_name => _category_name;

  updateProduct(int categoryId) async {
    _products = await _dbService.fetchProductByCategory(categoryId);
    _categories = await _dbService.fetchCategory();
    _category_name = await _dbService.fetchCategoryNameById(categoryId);
  }
}
