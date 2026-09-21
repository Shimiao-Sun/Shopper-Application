import 'package:flutter/material.dart';
import 'text_widget.dart';
import 'app_constants.dart';

class OrderDetailContainer extends StatefulWidget {
  final String productName;
  final String productImagePath;
  final String price;
  final int quantityGiven;
  final String sellerName;

  const OrderDetailContainer(
      {Key? key,
      required this.productName,
      required this.productImagePath,
      required this.price,
      required this.quantityGiven,
      required this.sellerName})
      : super(key: key);

  @override
  State<OrderDetailContainer> createState() => _OrderDetailContainerState();
}

class _OrderDetailContainerState extends State<OrderDetailContainer> {
  bool isTrash = false;
  late int quantity;

  @override
  void initState() {
    quantity = widget.quantityGiven;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 107,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppConstants.txtFieldColor)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.productImagePath,
                width: 90, height: 70, fit: BoxFit.fill),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 14,
                      child: TextWidget(
                        txt: widget.productName,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 142,
                      child: TextWidget(
                        txt: widget.sellerName,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 80),
                Row(
                  children: [
                    TextWidget(
                      txt: "\$${widget.price}",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(
                      width: 150,
                    ),
                    if (quantity > 1)
                      TextWidget(
                        txt: "$quantity items",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    if (quantity == 1)
                      TextWidget(
                        txt: "$quantity item",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        textColor: AppConstants.primaryColor,
                      ),
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
