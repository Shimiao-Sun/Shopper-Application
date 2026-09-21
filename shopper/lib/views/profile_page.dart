import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/viewmodels/account_page_viewmodel.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import 'package:shopper/viewmodels/control_view_viewmodel.dart';
import 'package:shopper/viewmodels/wishlist_page_viewmodel.dart';
import 'package:shopper/views/edit_profile_page.dart';
import '../models/account.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const TextStyle titleText = TextStyle(
      fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15);
  static const TextStyle answerText =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    AccountViewModel accountViewModel = context.watch<AccountViewModel>();
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    CartViewModel cartViewModel = context.watch<CartViewModel>();
    WishlistViewModel wishlistViewModel = context.watch<WishlistViewModel>();

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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
        ),
        Center(
          child: Text(
            "Profile",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
            child: RichText(
                text: TextSpan(children: [
              const TextSpan(text: 'Account Number: ', style: titleText),
              TextSpan(text: Account.user.userID.toString(), style: answerText)
            ]))),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
            child: RichText(
                text: TextSpan(children: [
              const TextSpan(text: 'First Name: ', style: titleText),
              TextSpan(text: Account.user.firstName, style: answerText)
            ]))),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
            child: RichText(
                text: TextSpan(children: [
              const TextSpan(text: 'Last Name: ', style: titleText),
              TextSpan(text: Account.user.lastName, style: answerText)
            ]))),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
            child: RichText(
                text: TextSpan(children: [
              const TextSpan(text: 'Email: ', style: titleText),
              TextSpan(text: Account.user.email, style: answerText)
            ]))),
        Center(
            child: ElevatedButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()));
            setState(() {});
          },
          child: const Text("Edit Profile"),
        )),
        const SizedBox(
          height: 10,
        ),
        Center(
            child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:
                        const Text("Are you sure you want delete your account"),
                    content: const Text(
                        "All your information will be delete and you may not able to check your orders anymore, please make sure all your orders are completed."),
                    actions: [
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            await accountViewModel.deleteAccount();
                            Account.user.logout();
                            cartViewModel.carts.clear();
                            wishlistViewModel.wishlists.clear();

                            controlViewModel.changeCurrentScreen(1);
                          },
                          child: const Text("Yes")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("No"))
                    ],
                  );
                });
          },
          child: const Text("Delete Account"),
        )),
      ]),
    );
  }
}
