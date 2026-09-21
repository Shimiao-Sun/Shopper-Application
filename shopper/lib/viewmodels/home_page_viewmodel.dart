import 'package:flutter/material.dart';
import '../models/DBService.dart';
import '../models/category.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<Category> _categories = [];
  int _callCounter = 0;
  List<Category> get categories => _categories;
  String _version = "0.0.0";
  String get version => _version;
  HomeViewModel() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _version = packageInfo.version;
    });
  }
  updateCategory() async {
    _categories = await _dbService.fetchCategory();

    _callCounter++;
    if ((_callCounter + 1) % 2 == 0) {
      notifyListeners();
    }
  }
}
