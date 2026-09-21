import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/Wishlist.dart';
import 'package:shopper/style/button_widget.dart';
import 'package:shopper/viewmodels/wishlist_page_viewmodel.dart';
import '../style/wishlist_container.dart';
import '../viewmodels/control_view_viewmodel.dart';

class WishlistBody extends StatelessWidget {
  const WishlistBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    WishlistViewModel wishlistViewModel = context.watch<WishlistViewModel>();

    return SafeArea(
        child: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(top: 19, left: 16, right: 16)),
            Center(
              child: Text(
                "Your Wishlist Items",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: <Widget>[
                for (Wishlist i in wishlistViewModel.wishlists)
                  Column(children: [
                    WishlistContainer(
                      productName: i.product.title,
                      productImagePath: i.product.image,
                      price: "\$${i.product.price}",
                      sellerName: i.product.sellerName,
                      listID: wishlistViewModel.wishlists.indexOf(i),
                      productId: i.product.id,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ])
              ]),
            ),
            const SizedBox(height: 7),
            Center(
              child: ButtonWidget(
                buttonText: "Add More Items",
                onPressed: () {
                  controlViewModel.changeCurrentScreen(0);
                },
                height: 20,
                width: 120,
                textSize: 10,
                color: const Color.fromARGB(255, 11, 168, 246),
              ),
            ),
            const SizedBox(height: 28),
            const Divider(thickness: 1, height: 0),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ));
  }
}
