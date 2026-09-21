import 'package:flutter/material.dart';
import 'text_widget.dart';
import 'app_constants.dart';

class OrderContainer extends StatefulWidget {
  final int orderID, itemNum, price;
  final String sellerName;
  final String orderStatus;

  const OrderContainer(
      {Key? key,
      required this.orderID,
      required this.sellerName,
      required this.orderStatus,
      required this.itemNum,
      required this.price})
      : super(key: key);

  @override
  State<OrderContainer> createState() => _OrderContainer();
}

class _OrderContainer extends State<OrderContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 160,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppConstants.txtFieldColor)),
        child: Row(children: [
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                txt: "Order Id: ${widget.orderID.toString()}",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                textColor: Colors.black,
              ),
              TextWidget(
                txt: "Order From: ${widget.sellerName}",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppConstants.subTxtColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(
                    txt: "Order Status:",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppConstants.subTxtColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget(
                    txt: widget.orderStatus,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    textColor: AppConstants.titleTextColor,
                  ),
                ],
              ),
              Row(
                children: [
                  const TextWidget(
                    txt: "Item:",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppConstants.subTxtColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget(
                    txt: "${widget.itemNum} items purchased",
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    textColor: AppConstants.titleTextColor,
                  ),
                ],
              ),
              Row(
                children: [
                  const TextWidget(
                    txt: "Price:",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppConstants.subTxtColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget(
                    txt: "\$${widget.price}",
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    textColor: AppConstants.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ]));
  }
}
