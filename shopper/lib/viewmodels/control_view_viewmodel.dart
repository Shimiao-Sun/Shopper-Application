import 'package:flutter/material.dart';
import 'package:shopper/views/item_page.dart';
import 'package:shopper/views/order_success_page.dart';
import '../views/account_page.dart';
import '../views/checkout_page.dart';
import '../views/login_page.dart';
import '../models/account.dart';
import '../views/cart_page.dart';
import '../../views/home_page.dart';
import '../../views/category_page.dart';
import '../../views/wishlist_page.dart';
import '../views/search_page.dart';

class ControlViewModel extends ChangeNotifier {
  Widget _currentScreen = HomePage();
  int _navigatorIndex = 0;
  int homeIndex = 0;
  int categoryId = 0;
  int itemId = 0;
  int cartIndex = 0;
  int homeOrCatPage = 0;
  String str = "";
  final bool _flag = true;
  int itemPageOrigin = 0;

  bool get flag => _flag;
  Widget get currentScreen => _currentScreen;
  int get navigatorIndex => _navigatorIndex;

  changeCurrentScreen(int index) async {
    _navigatorIndex = index;
    switch (index) {
      case 0:
        switch (homeIndex) {
          case 0:
            _currentScreen = HomePage();
            homeOrCatPage = 0;
            notifyListeners();
            break;
          case 4:
            _currentScreen = CategoryPage(categoryId);
            _navigatorIndex = 0;
            notifyListeners();
            break;
          case 8:
            switch (itemPageOrigin) {
              case 0:
                _currentScreen = ItemPage(itemId, itemPageOrigin);
                _navigatorIndex = 0;
                notifyListeners();
                break;
              case 1:
                switch (homeOrCatPage) {
                  case 0:
                    _currentScreen = HomePage();
                    notifyListeners();
                    break;
                  case 1:
                    _currentScreen = CategoryPage(categoryId);
                    _navigatorIndex = 0;
                    notifyListeners();
                    break;
                }
                break;
              case 2:
                _currentScreen = HomePage();
                notifyListeners();
                break;
            }
        }
        break;
      case 1:
        switch (Account.getLoginState(Account.user)) {
          case 0:
            _currentScreen = const LoginPage();
            notifyListeners();
            break;
          case 1:
            _currentScreen = const AccountPage();
            notifyListeners();
            break;
        }
        break;
      case 2:
        _currentScreen = const WishlistPage();
        notifyListeners();
        break;
      case 3:
        switch (cartIndex) {
          case 0:
            _currentScreen = const CartPage();
            notifyListeners();
            break;
          case 5:
            switch (Account.getLoginState(Account.user)) {
              case 0:
                _currentScreen = const CartPage();
                cartIndex = 0;
                notifyListeners();
                break;
              case 1:
                _currentScreen = const CheckoutPage();
                _navigatorIndex = 3;
                notifyListeners();
                break;
            }
        }
        break;
      case 4:
        _currentScreen = CategoryPage(categoryId);
        _navigatorIndex = 0;
        homeIndex = 4;
        homeOrCatPage = 1;
        notifyListeners();
        break;
      case 5:
        _currentScreen = const CheckoutPage();
        _navigatorIndex = 3;
        cartIndex = 5;
        notifyListeners();
        break;
      case 6:
        _currentScreen = const OrderSuccessPage();
        _navigatorIndex = 3;
        cartIndex = 0;
        homeIndex = 0;
        notifyListeners();
        break;
      case 7:
        _currentScreen = SearchPage(str);
        _navigatorIndex = 0;
        homeIndex = 0;
        notifyListeners();
        break;
      case 8:
        _currentScreen = ItemPage(itemId, itemPageOrigin);
        if (itemPageOrigin == 1) {
          _navigatorIndex = 3;
        } else if (itemPageOrigin == 2) {
          _navigatorIndex = 0;
          homeOrCatPage = 0;
        } else if (itemPageOrigin == 3) {
          _navigatorIndex = 2;
        } else {
          _navigatorIndex = 0;
          homeOrCatPage = 1;
        }
        homeIndex = 0;
        notifyListeners();
        break;
    }
  }
}
