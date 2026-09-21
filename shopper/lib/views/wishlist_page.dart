import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'wishlist_body.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context),
        body: const WishlistBody(),
      );

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/images/logo/shopper.png',
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light),
    );
  }
}
