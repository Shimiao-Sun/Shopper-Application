import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/account.dart';
import 'package:shopper/models/order.dart';
import 'package:shopper/style/order_container.dart';
import 'package:shopper/viewmodels/account_page_viewmodel.dart';

import 'order_detail.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AccountViewModel accountViewModel = context.watch<AccountViewModel>();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                accountViewModel.clearOrder();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
        ),
        body: FutureBuilder<int>(
            future: accountViewModel.getOrders(Account.user.userID),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (!snapshot.hasData) {
                // Data is loading
                return const Center(child: CircularProgressIndicator());
              }
              return SafeArea(
                  child: SingleChildScrollView(
                      child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.only(
                                      top: 19, left: 16, right: 16)),
                              Center(
                                child: Text(
                                  "Order",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(children: <Widget>[
                                  for (Order i in accountViewModel.order)
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetailPage(
                                                        orderId: i.orderID,
                                                        products: i.products,
                                                        prices: i.price,
                                                        order: i,
                                                      )));
                                        },
                                        child: Column(children: [
                                          OrderContainer(
                                            orderID: i.orderID,
                                            sellerName: i.sellerName,
                                            orderStatus: i.orderStatus,
                                            itemNum: i.itemNum,
                                            price: i.price,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                        ])),
                                ]),
                              ),
                            ],
                          ))));
            }));
  }
}
