import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/account.dart';
import 'package:shopper/style/text_widget.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import 'package:shopper/viewmodels/wishlist_page_viewmodel.dart';
import 'package:shopper/views/order_page.dart';
import 'package:shopper/views/profile_page.dart';
import '../style/button_widget.dart';
import '../viewmodels/control_view_viewmodel.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    CartViewModel cartViewModel = context.watch<CartViewModel>();
    WishlistViewModel wishlistViewModel = context.watch<WishlistViewModel>();

    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/logo/shopper.png',
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
          elevation: 0,
          shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        body: Column(
          children: [
            const Padding(
                padding: EdgeInsets.only(top: 19, left: 16, right: 16)),
            Center(
              child: Text(
                "Account",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
              child: Row(
                children: const [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.person_outline,
                    size: 30,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextWidget(
                    txt: "Profile",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const OrderPage()));
              },
              child: Row(
                children: const [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 30,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextWidget(
                    txt: "Orders",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ButtonWidget(
                buttonText: "Logout",
                onPressed: () {
                  Account.user.logout();
                  cartViewModel.carts.clear();
                  wishlistViewModel.wishlists.clear();
                  controlViewModel.changeCurrentScreen(1);
                },
                height: 57,
                width: 300,
                textSize: 16,
                color: Colors.blue[600],
              ),
            )
          ],
        ));
  }
}
