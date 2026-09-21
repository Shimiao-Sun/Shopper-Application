import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import 'package:shopper/viewmodels/control_view_viewmodel.dart';
import 'package:shopper/viewmodels/item_page_viewmodel.dart';
import 'package:shopper/viewmodels/wishlist_page_viewmodel.dart';

import '../models/cart.dart';
import '../models/Product.dart';
import '../style/text_widget.dart';
import '../style/app_constants.dart';

class ItemPage extends StatefulWidget {
  final int itemId;
  final int originPage;

  const ItemPage(this.itemId, this.originPage, {Key? key}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Product item = Product(
      price: 0,
      id: 0,
      image: '',
      sellerName: '',
      description: '',
      title: '',
      sellerId: 0,
      category: '',
      quantity: 0);
  int quantity = 1;
  bool inCart = false;

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    ItemViewModel itemViewModel = context.watch<ItemViewModel>();
    CartViewModel cartViewModel = context.watch<CartViewModel>();
    WishlistViewModel wishlistViewModel = context.watch<WishlistViewModel>();

    return Scaffold(
        appBar: AppBar(
            title: Image.asset(
              'assets/images/logo/shopper.png',
              fit: BoxFit.cover,
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            shape:
                const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.blue),
              onPressed: () {
                if (widget.originPage == 0) {
                  // Category Page
                  controlViewModel.homeIndex = 4;
                  controlViewModel.changeCurrentScreen(0);
                } else if (widget.originPage == 1) {
                  // Cart Page
                  controlViewModel.changeCurrentScreen(3);
                } else if (widget.originPage == 2) {
                  // Search Page
                  controlViewModel.homeIndex = 0;
                  controlViewModel.changeCurrentScreen(0);
                } else if (widget.originPage == 3) {
                  // Wishlist Page
                  controlViewModel.homeIndex = 0;
                  controlViewModel.changeCurrentScreen(2);
                }
              },
            )),
        body: FutureBuilder<Product>(
            future: itemViewModel.getItemDetails(widget.itemId),
            builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
              if (!snapshot.hasData) {
                // Data is loading
                return const Center(child: CircularProgressIndicator());
              } else {
                item = snapshot.data!;
                try {
                  quantity = cartViewModel.carts
                      .where((cart) => cart.product.id == item.id)
                      .first
                      .numOfItem;
                  inCart = true;
                } on StateError {
                  // Means the current item is not in the cart, do nothing
                }
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 25, right: 16, left: 16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.network(item.image,
                                      width: 275,
                                      height: 225,
                                      fit: BoxFit.fill),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.lightBlue)),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 12.5, 0, 0),
                                        child: TextWidget(
                                          txt: item.title,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          textColor:
                                              AppConstants.titleTextColor,
                                          align: TextAlign.left,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (wishlistViewModel
                                                  .checkItemInWishlist(item) ==
                                              -1)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 12.5, 0, 0),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () {
                                                  wishlistViewModel
                                                      .addItemToWishlist(item);
                                                  controlViewModel
                                                      .changeCurrentScreen(8);
                                                },
                                                color: Colors.blue[600],
                                                iconSize: 25,
                                                icon: const Icon(
                                                  Icons.favorite,
                                                ),
                                                alignment:
                                                    Alignment.centerRight,
                                              ),
                                            )
                                          else
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 12.5, 0, 0),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () {
                                                  wishlistViewModel
                                                      .removeItemToWishlist(
                                                          item);
                                                  controlViewModel
                                                      .changeCurrentScreen(8);
                                                },
                                                color: Colors.red,
                                                iconSize: 25,
                                                icon: const Icon(
                                                  Icons.favorite,
                                                ),
                                                alignment:
                                                    Alignment.centerRight,
                                              ),
                                            ),
                                          const SizedBox(width: 15),
                                          if (cartViewModel
                                                  .checkItemInCart(item) ==
                                              -1)
                                            ElevatedButton(
                                              onPressed: () {
                                                cartViewModel.addItemToCart(
                                                    item, quantity);
                                                controlViewModel
                                                    .changeCurrentScreen(8);
                                              },
                                              child: const Text("Add to Cart"),
                                            )
                                          else
                                            ElevatedButton(
                                                onPressed: () {
                                                  cartViewModel
                                                      .removeItemFromCart(item);
                                                  quantity = 1;
                                                  inCart = false;
                                                  controlViewModel
                                                      .changeCurrentScreen(8);
                                                },
                                                child: const Text(
                                                    "Remove from Cart"),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red)))
                                        ],
                                      )
                                    ]),
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        txt: item.sellerName,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        textColor: AppConstants.titleTextColor,
                                        align: TextAlign.left,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            splashColor: AppConstants
                                                .txtFieldColor
                                                .withOpacity(0.5),
                                            onTap: () async {
                                              if (quantity > 1) {
                                                if (inCart) {
                                                  Cart cartItem = cartViewModel
                                                      .carts
                                                      .where((cart) =>
                                                          cart.product.id ==
                                                          item.id)
                                                      .first;
                                                  cartItem.numOfItem--;
                                                  await cartViewModel
                                                      .updateCartItemQuantity(
                                                          cartViewModel.carts
                                                              .indexOf(
                                                                  cartItem));
                                                  setState(() {
                                                    quantity--;
                                                  });
                                                  controlViewModel
                                                      .changeCurrentScreen(8);
                                                } else {
                                                  quantity--;
                                                  controlViewModel
                                                      .changeCurrentScreen(8);
                                                }
                                              } else {
                                                // Do nothing
                                              }
                                            },
                                            child: Container(
                                              height: 24,
                                              width: 32,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                  ),
                                                  border: Border.all(
                                                      color: AppConstants
                                                          .txtFieldColor)),
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
                                                color:
                                                    AppConstants.txtFieldColor
                                                //border: Border.all(color: Color(0xffEBF0FF))
                                                ),
                                            child: TextWidget(
                                              txt: "$quantity",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              textColor:
                                                  AppConstants.subTxtColor,
                                            ),
                                          ),
                                          InkWell(
                                            splashColor: AppConstants
                                                .txtFieldColor
                                                .withOpacity(0.5),
                                            onTap: () async {
                                              if (inCart) {
                                                Cart cartItem = cartViewModel
                                                    .carts
                                                    .where((cart) =>
                                                        cart.product.id ==
                                                        item.id)
                                                    .first;
                                                cartItem.numOfItem++;
                                                await cartViewModel
                                                    .updateCartItemQuantity(
                                                        cartViewModel.carts
                                                            .indexOf(cartItem));
                                                setState(() {
                                                  quantity++;
                                                });
                                                controlViewModel
                                                    .changeCurrentScreen(8);
                                              } else {
                                                quantity++;
                                                controlViewModel
                                                    .changeCurrentScreen(8);
                                              }
                                            },
                                            child: Container(
                                              height: 24,
                                              width: 32,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5),
                                                  ),
                                                  border: Border.all(
                                                      color: AppConstants
                                                          .txtFieldColor)),
                                              child: const Icon(
                                                Icons.add,
                                                color: AppConstants.subTxtColor,
                                                size: 16,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ]),
                                TextWidget(
                                  txt: "\$${item.price.toString()}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppConstants.titleTextColor,
                                  align: TextAlign.left,
                                ),
                                const SizedBox(height: 20),
                                const TextWidget(
                                  txt: "Description",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppConstants.titleTextColor,
                                  align: TextAlign.left,
                                ),
                                Flexible(
                                    child: TextWidget(
                                  txt: item.description,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  textColor: AppConstants.titleTextColor,
                                  align: TextAlign.left,
                                )),
                              ]))),
                );
              }
            }));
  }
}
