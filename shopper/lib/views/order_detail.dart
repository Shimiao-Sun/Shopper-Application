import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopper/models/Product.dart';
import 'package:shopper/models/order.dart';
import 'package:shopper/style/text_widget.dart';
import 'package:shopper/style/app_constants.dart';
import 'package:shopper/style/order_detail_container.dart';

class OrderDetailPage extends StatelessWidget {
  final int orderId;
  final List<Product> products;
  final int prices;
  final Order order;

  const OrderDetailPage(
      {Key? key,
      required this.orderId,
      required this.products,
      required this.prices,
      required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding:
                              EdgeInsets.only(top: 19, left: 16, right: 16)),
                      Center(
                        child: Column(children: [
                          Text(
                            "Order Detail",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                          Text(
                            "ID: $orderId",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            txt: "Product",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                      for (var i in products)
                        OrderDetailContainer(
                            productName: i.title,
                            productImagePath: i.image,
                            price: i.price.toString(),
                            quantityGiven: i.quantity,
                            sellerName: i.sellerName),
                      Row(
                        children: const [
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            txt: "Shipping Detail",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 130,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: AppConstants.txtFieldColor)),
                          child: Row(children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const TextWidget(
                                        txt: "Street Address:",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(
                                        txt: order.streetAddress,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const TextWidget(
                                        txt: "Suburb:",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(
                                        txt: order.suburb,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const TextWidget(
                                        txt: "State:",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(
                                        txt: order.state,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const TextWidget(
                                        txt: "Postcode:",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(
                                        txt: order.postcode.toString(),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const TextWidget(
                                        txt: "Country:",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(
                                        txt: order.country,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                              ],
                            )
                          ])),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            txt: "Prices",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: AppConstants.txtFieldColor)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 0),
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
                              const SizedBox(width: 150),
                              TextWidget(
                                  txt: "\$$prices",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  textColor: AppConstants.primaryColor),
                            ],
                          ),
                        ),
                      )
                    ])),
          ),
        ));
  }
}
