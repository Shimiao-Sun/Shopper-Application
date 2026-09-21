import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import '../viewmodels/control_view_viewmodel.dart';
import 'text_widget.dart';
import 'app_constants.dart';

class CartContainer extends StatefulWidget {
  final String productName;
  final String productImagePath;
  final String price;
  final int quantityGiven;
  final String sellerName;
  final int listID;
  final int productId;

  const CartContainer(
      {Key? key,
      required this.productName,
      required this.productImagePath,
      required this.price,
      required this.quantityGiven,
      required this.sellerName,
      required this.listID,
      required this.productId})
      : super(key: key);

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  bool isTrash = false;
  late int quantity;

  @override
  void initState() {
    quantity = widget.quantityGiven;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    CartViewModel cartViewModel = context.watch<CartViewModel>();

    return GestureDetector(
        onTap: () {
          controlViewModel.itemId = widget.productId;
          controlViewModel.itemPageOrigin = 1;
          controlViewModel.changeCurrentScreen(8);
        },
        child: Container(
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
                      Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isTrash = !isTrash;
                                });
                                await cartViewModel.removeItemFromCart(
                                    cartViewModel.carts[widget.listID].product);

                                controlViewModel.changeCurrentScreen(3);
                              },
                              child: isTrash
                                  ? const Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: AppConstants.lightRedColor,
                                        size: 24,
                                      ))
                                  : const Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: AppConstants.subTxtColor,
                                        size: 24,
                                      ))),
                        ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            splashColor:
                                AppConstants.txtFieldColor.withOpacity(0.5),
                            onTap: () async {
                              if (quantity > 1) {
                                cartViewModel.carts[widget.listID].numOfItem -=
                                    1;
                                await cartViewModel
                                    .updateCartItemQuantity(widget.listID);
                                setState(() {
                                  quantity = quantity - 1;
                                });

                                controlViewModel.changeCurrentScreen(3);
                              } else {
                                null;
                              }
                            },
                            child: Container(
                              height: 24,
                              width: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                  border: Border.all(
                                      color: AppConstants.txtFieldColor)),
                              child: const Icon(
                                Icons.remove,
                                color: AppConstants.subTxtColor,
                                size: 16,
                              ),
                            ),
                          ),
                          Container(
                            height: 24,
                            width: 32,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: AppConstants.txtFieldColor
                                //border: Border.all(color: Color(0xffEBF0FF))
                                ),
                            child: TextWidget(
                              txt: "$quantity",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppConstants.subTxtColor,
                            ),
                          ),
                          InkWell(
                            splashColor:
                                AppConstants.txtFieldColor.withOpacity(0.5),
                            onTap: () async {
                              cartViewModel.carts[widget.listID].numOfItem += 1;
                              await cartViewModel
                                  .updateCartItemQuantity(widget.listID);
                              setState(() {
                                quantity = quantity + 1;
                              });
                              controlViewModel.changeCurrentScreen(3);
                            },
                            child: Container(
                              height: 24,
                              width: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  border: Border.all(
                                      color: AppConstants.txtFieldColor)),
                              child: const Icon(
                                Icons.add,
                                color: AppConstants.subTxtColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 70),
                      TextWidget(
                        txt: widget.price,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        textColor: Colors.black,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
