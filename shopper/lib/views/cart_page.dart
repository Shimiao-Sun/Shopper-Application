import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cart_body.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context),
        body: const Body(),
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
