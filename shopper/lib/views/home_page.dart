import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopper/viewmodels/category_page_viewmodel.dart';
import '../models/category.dart';
import '../viewmodels/control_view_viewmodel.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_page_viewmodel.dart';
import '../viewmodels/search_page_viewmodel.dart';

class HomePage extends StatelessWidget {
  final _controller = TextEditingController();
  @override
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    SearchViewModel searchViewModel = context.watch<SearchViewModel>();
    HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    homeViewModel.updateCategory();
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/logo/shopper.png',
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
          shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  homeViewModel.version,
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(1)),
                )),
          ],
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: _controller.clear,
                    icon: const Icon(Icons.clear),
                  ),
                  hintText: 'Search for products',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await searchViewModel.updateProduct(_controller.text);
                      controlViewModel.changeCurrentScreen(7);
                    },
                    icon: const Icon(Icons.search),
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
                  "CATEGORIES",
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
                    itemCount: homeViewModel.categories.length,
                    //itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) => CategoryCard(
                      category: homeViewModel.categories[index],
                    ),
                  ),
                ),
              ),
            ]));
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);
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
                padding: const EdgeInsets.all(10),
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(children: <Widget>[
                  Text(category.title),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                  ),
                  Image.network(category.image,
                      width: 110, height: 100, fit: BoxFit.fill),
                ])),
          ),
        ],
      ),
    );
  }
}
