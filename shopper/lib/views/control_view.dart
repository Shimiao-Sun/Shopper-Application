import 'package:flutter/material.dart';
import '../viewmodels/control_view_viewmodel.dart';
import 'package:provider/provider.dart';

class ControlView extends StatelessWidget {
  const ControlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();

    return Scaffold(
        body: controlViewModel.currentScreen,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            controlViewModel.changeCurrentScreen(index);
          },
          //showSelectedLabels: false,
          //showUnselectedLabels: false,
          currentIndex: controlViewModel.navigatorIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Carts',
            ),
          ],
        ));
  }
}
