import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopper/viewmodels/authentication_viewmodel.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import 'package:shopper/viewmodels/category_page_viewmodel.dart';
import 'package:shopper/viewmodels/checkout_page_viewmodel.dart';
import 'package:shopper/viewmodels/item_page_viewmodel.dart';
import 'viewmodels/account_page_viewmodel.dart';
import 'viewmodels/wishlist_page_viewmodel.dart';
import 'views/control_view.dart';
import '../viewmodels/control_view_viewmodel.dart';
import '../viewmodels/home_page_viewmodel.dart';
import '../viewmodels/category_page_viewmodel.dart';
import '../viewmodels/search_page_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControlViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => CheckoutViewModel()),
        ChangeNotifierProvider(create: (_) => WishlistViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => AccountViewModel()),
        ChangeNotifierProvider(create: (_) => ItemViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopper',
        home: ControlView(),
      ),
    );
  }
}
