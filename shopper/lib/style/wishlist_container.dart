import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import '../viewmodels/control_view_viewmodel.dart';
import '../viewmodels/wishlist_page_viewmodel.dart';
import 'text_widget.dart';
import 'app_constants.dart';

class WishlistContainer extends StatefulWidget {
  final String productName;
  final String productImagePath;
  final String price;
  final String sellerName;
  final int listID;
  final int productId;

  const WishlistContainer(
      {Key? key,
      required this.productName,
      required this.productImagePath,
      required this.price,
      required this.sellerName,
      required this.listID,
      required this.productId})
      : super(key: key);

  @override
  State<WishlistContainer> createState() => _WishlistContainerState();
}

class _WishlistContainerState extends State<WishlistContainer> {
  bool isTrash = false;
  bool inCart = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    WishlistViewModel wishlistViewModel = context.watch<WishlistViewModel>();
    CartViewModel cartViewModel = context.watch<CartViewModel>();

    return GestureDetector(
        onTap: () {
          controlViewModel.itemId = widget.productId;
          controlViewModel.itemPageOrigin = 3;
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

                                await wishlistViewModel.removeItemFromWishlist(
                                    wishlistViewModel
                                        .wishlists[widget.listID].product);
                                wishlistViewModel.wishlists
                                    .removeAt(widget.listID);

                                controlViewModel.changeCurrentScreen(2);
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
                      SizedBox(
                        width: 80,
                        child: TextWidget(
                          txt: widget.price,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          textColor: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (cartViewModel.checkItemInCart(wishlistViewModel
                              .wishlists[widget.listID].product) ==
                          -1)
                        GestureDetector(
                            onTap: () async {
                              await cartViewModel.addItemToCart(
                                  wishlistViewModel
                                      .wishlists[widget.listID].product,
                                  1);
                              controlViewModel.changeCurrentScreen(2);
                            },
                            child: const Padding(
                                padding: EdgeInsets.only(left: 90),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.blue,
                                  size: 24,
                                )))
                      else
                        GestureDetector(
                            onTap: () async {
                              await cartViewModel.removeItemFromCart(
                                  wishlistViewModel
                                      .wishlists[widget.listID].product);
                              controlViewModel.changeCurrentScreen(2);
                            },
                            child: const Padding(
                                padding: EdgeInsets.only(left: 90),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: AppConstants.lightRedColor,
                                  size: 24,
                                )))
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
