import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/category.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import 'package:shopper/viewmodels/wishlist_page_viewmodel.dart';
import '../viewmodels/control_view_viewmodel.dart';
import '../viewmodels/category_page_viewmodel.dart';
import '../models/Product.dart';
import '../models/category.dart';

class CategoryPage extends StatelessWidget {
  final int id;
  const CategoryPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    CategoryViewModel categoryViewModel = context.watch<CategoryViewModel>();

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
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            controlViewModel.homeIndex = 0;
            controlViewModel.changeCurrentScreen(0);
          },
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemCount: categoryViewModel.categories.length,
                itemBuilder: (context, index) => CategoryCard(
                  category: categoryViewModel.categories[index],
                  currentCategory: id,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: Text(
                categoryViewModel.category_name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: categoryViewModel.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    product: categoryViewModel.products[index],
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartViewModel cartViewModel = context.watch<CartViewModel>();
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    WishlistViewModel wishlistViewModel = context.watch<WishlistViewModel>();

    return GestureDetector(
        onTap: () {
          controlViewModel.itemId = product.id;
          controlViewModel.itemPageOrigin = 0;
          controlViewModel.changeCurrentScreen(8);
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Image.network(product.image,
                                width: 90, height: 70, fit: BoxFit.fill),
                          ),
                          if (cartViewModel.checkItemInCart(product) == -1)
                            Align(
                              alignment: Alignment.bottomRight,
                              heightFactor: 3,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    cartViewModel.addItemToCart(product, 1);
                                    controlViewModel.changeCurrentScreen(4);
                                  },
                                  color: Colors.blue[600],
                                  iconSize: 25,
                                  icon: const Icon(
                                    Icons.add_circle,
                                  )),
                            )
                          else
                            Align(
                              alignment: Alignment.bottomRight,
                              heightFactor: 3,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    cartViewModel.removeItemFromCart(product);
                                    controlViewModel.changeCurrentScreen(4);
                                  },
                                  color: Colors.red,
                                  iconSize: 25,
                                  icon: const Icon(
                                    Icons.remove_circle,
                                  )),
                            )
                        ],
                      ),
                      Stack(children: <Widget>[
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: const StrutStyle(fontSize: 10.0),
                          text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              text: product.title),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            heightFactor: 3.8,
                            child: Text(
                              "\$${product.price}",
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.right,
                            )),
                        Container(
                          alignment: Alignment.center,
                        ),
                        if (wishlistViewModel.checkItemInWishlist(product) ==
                            -1)
                          Align(
                            alignment: Alignment.centerRight,
                            heightFactor: 3,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  wishlistViewModel.addItemToWishlist(product);
                                  controlViewModel.changeCurrentScreen(4);
                                },
                                color: Colors.blue[600],
                                iconSize: 17,
                                icon: const Icon(
                                  Icons.favorite,
                                )),
                          )
                        else
                          Align(
                              alignment: Alignment.centerRight,
                              heightFactor: 3,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    wishlistViewModel
                                        .removeItemToWishlist(product);
                                    controlViewModel.changeCurrentScreen(4);
                                  },
                                  color: Colors.red,
                                  iconSize: 17,
                                  icon: const Icon(
                                    Icons.favorite,
                                  ))),
                      ])
                    ],
                  ),
                ),
              )
            ]));
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final int currentCategory;

  const CategoryCard(
      {Key? key, required this.category, required this.currentCategory})
      : super(key: key);
  //final Function press;

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    CategoryViewModel categoryViewModel = context.watch<CategoryViewModel>();

    return GestureDetector(
      //onTap: press,
      onTap: () async {
        controlViewModel.categoryId = category.id;
        await categoryViewModel.updateProduct(category.id);
        controlViewModel.changeCurrentScreen(4);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: currentCategory == category.id
                  ? BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(5),
                    )
                  : BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
              child: Column(
                children: <Widget>[
                  Text(category.title,
                      style: const TextStyle(
                        fontSize: 15,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
