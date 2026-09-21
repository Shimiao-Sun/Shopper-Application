import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/category.dart';
import 'package:shopper/style/text_widget.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import '../viewmodels/control_view_viewmodel.dart';
import '../viewmodels/search_page_viewmodel.dart';
import '../models/Product.dart';
import '../models/category.dart';

class SearchPage extends StatelessWidget {
  final String str;
  const SearchPage(this.str, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    SearchViewModel searchViewModel = context.watch<SearchViewModel>();

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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: Text(
                searchViewModel.searchString,
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
                  itemCount: searchViewModel.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    product: searchViewModel.products[index],
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

    return GestureDetector(
      onTap: () {
        controlViewModel.itemId = product.id;
        controlViewModel.itemPageOrigin = 2;
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
                                controlViewModel.changeCurrentScreen(7);
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
                                controlViewModel.changeCurrentScreen(7);
                              },
                              color: Colors.red,
                              iconSize: 25,
                              icon: const Icon(
                                Icons.remove_circle,
                              )),
                        )
                    ],
                  ),
                  Expanded(
                    child: TextWidget(
                      txt: product.title,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      textColor: Colors.black,
                    ),
                  ),
                  Text("\$${product.price}",
                      style: const TextStyle(
                        fontSize: 10,
                      )),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      color: Colors.blue[600],
                      iconSize: 25,
                      icon: const Icon(
                        Icons.favorite,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
    return GestureDetector(
      //onTap: press,
      onTap: () {
        controlViewModel.categoryId = category.id;
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
