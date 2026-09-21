import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/style/text_widget.dart';
import 'package:shopper/style/app_constants.dart';
import 'package:shopper/style/text_form_field_widget.dart';
import 'package:shopper/style/button_widget.dart';
import 'package:shopper/models/account.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import 'package:shopper/viewmodels/wishlist_page_viewmodel.dart';
import 'package:shopper/views/signup_page.dart';
import '../viewmodels/authentication_viewmodel.dart';

import '../viewmodels/control_view_viewmodel.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    CartViewModel cartViewModel = context.watch<CartViewModel>();
    WishlistViewModel wishlistViewModel = context.watch<WishlistViewModel>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 112, left: 16, right: 16),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo/shopper.png',
                      ),
                      const SizedBox(height: 16),
                      const TextWidget(
                        txt: "Welcome to Shopper",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppConstants.titleTextColor,
                      ),
                      const SizedBox(height: 8),
                      const TextWidget(
                          txt: "Sign in to continue",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: AppConstants.subTxtColor),
                      const SizedBox(
                        height: 28,
                      ),
                      TextFormFieldWidget(
                        hintText: "Your Email",
                        prefixIcon: const Icon(Icons.mail_lock_outlined),
                        maxLines: 1,
                        minLines: 1,
                        isPasswordField: false,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter Your Email";
                          } else {
                            // Check the email format
                            if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val) ==
                                false) {
                              return "Please enter a email";
                            }
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormFieldWidget(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        maxLines: 1,
                        minLines: 1,
                        isPasswordField: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Your Password or Username is not correct !";
                          }

                          if (Account.user.loginState == 1) {
                            return null;
                          } else {
                            return "Your Password or Username is not correct !";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ButtonWidget(
                        buttonText: "Sign In",
                        onPressed: () async {
                          await authViewModel.checkInfo();
                          if (formKey.currentState!.validate()) {
                            await cartViewModel
                                .getUserCart(Account.user.userID);

                            await wishlistViewModel
                                .getUserWishlist(Account.user.userID);

                            controlViewModel.changeCurrentScreen(1);
                          }
                        },
                        height: 57,
                        width: 300,
                        textSize: 16,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()));
                          },
                          child: const TextWidget(
                            txt: "Forgot Password?",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            textColor: AppConstants.primaryColor,
                          )),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TextWidget(
                              txt: "Don't have a account?",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppConstants.subTxtColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              child: const TextWidget(
                                txt: "Register",
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                textColor: AppConstants.primaryColor,
                              ),
                            ),
                          ])
                    ],
                  ),
                ),
              ),
            )));
  }
}
