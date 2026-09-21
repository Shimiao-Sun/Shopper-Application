import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/cart.dart';
import 'package:shopper/models/account.dart';
import 'package:shopper/style/button_widget.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import '../style/text_widget.dart';
import '../viewmodels/control_view_viewmodel.dart';
import '../style/cart_container.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    CartViewModel cartViewModel = context.watch<CartViewModel>();

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
                "Your Cart Items",
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
                for (Cart i in cartViewModel.carts)
                  Column(children: [
                    CartContainer(
                        productName: i.product.title,
                        productImagePath: i.product.image,
                        price: "\$${i.product.price}",
                        quantityGiven: i.numOfItem,
                        sellerName: i.product.sellerName,
                        listID: cartViewModel.carts.indexOf(i),
                        productId: i.product.id),
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
            Padding(
              padding: const EdgeInsets.only(left: 45, right: 45),
              child: Row(
                children: [
                  const TextWidget(
                      txt: "Subtotal",
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  const SizedBox(width: 5),
                  const TextWidget(
                      txt: "Inc. GST",
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                  const SizedBox(width: 80),
                  TextWidget(
                      txt: "\$${Cart.totalPrice(cartViewModel.carts)}",
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ButtonWidget(
                buttonText:
                    "CheckOut (${Cart.totalItem(cartViewModel.carts)} items)",
                onPressed: () {
                  if (Account.user.loginState == 0) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Please Login"),
                            content: const Text(
                                "Please login before continuing to checkout."),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    controlViewModel.changeCurrentScreen(1);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Login"))
                            ],
                          );
                        });
                  } else {
                    controlViewModel.changeCurrentScreen(5);
                  }
                },
                height: 57,
                width: 300,
                textSize: 16,
                color: Colors.blue[600],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
