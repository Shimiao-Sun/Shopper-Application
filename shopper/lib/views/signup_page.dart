import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/account.dart';
import 'package:shopper/style/text_form_field_widget.dart';
import 'package:shopper/style/button_widget.dart';
import 'package:shopper/views/signup_success_page.dart';
import '../style/text_widget.dart';
import '../style/app_constants.dart';
import '../viewmodels/authentication_viewmodel.dart';
import 'signup_failed_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    AuthViewModel authViewModel = context.watch<AuthViewModel>();

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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 16, left: 16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo/shopper.png',
                    ),
                    const SizedBox(height: 16),
                    const TextWidget(
                      txt: "Let's Get Started",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: AppConstants.titleTextColor,
                    ),
                    const SizedBox(height: 8),
                    const TextWidget(
                      txt: "Create a new account",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppConstants.subTxtColor,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormFieldWidget(
                        hintText: "First Name",
                        minLines: 1,
                        maxLines: 1,
                        prefixIcon: const Icon(Icons.person_outline),
                        isPasswordField: false,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter your first name";
                          } else {
                            Account.user.firstName = val;
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 13,
                    ),
                    TextFormFieldWidget(
                        hintText: "Last Name",
                        minLines: 1,
                        maxLines: 1,
                        prefixIcon: const Icon(Icons.person_outline),
                        isPasswordField: false,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter your last name";
                          } else {
                            Account.user.lastName = val;
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 13,
                    ),
                    TextFormFieldWidget(
                        hintText: "Email",
                        minLines: 1,
                        maxLines: 1,
                        prefixIcon: const Icon(Icons.email_outlined),
                        isPasswordField: false,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter your Email";
                          } else {
                            // Check the email format
                            if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val) ==
                                false) {
                              return "Please enter an email";
                            }
                            Account.user.email = val;
                            return null;
                          }
                        }),
                    const SizedBox(height: 13),
                    TextFormFieldWidget(
                        hintText: "Password",
                        minLines: 1,
                        maxLines: 1,
                        prefixIcon: const Icon(Icons.lock_outline),
                        isPasswordField: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter your password";
                          } else {
                            Account.user.password = val;
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 13,
                    ),
                    TextFormFieldWidget(
                        hintText: "Confirm Password",
                        minLines: 1,
                        maxLines: 1,
                        prefixIcon: const Icon(Icons.lock),
                        isPasswordField: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please enter your password again";
                          }
                          if (val == Account.user.password) {
                            return null;
                          } else {
                            return "Passwords do not match!";
                          }
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonWidget(
                      buttonText: "Sign Up",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Generate random slat
                          Account.user.hashPassword();
                          bool result = await authViewModel.saveInFo();

                          if (!mounted) return;

                          if (result) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const SignUpSuccess())));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const SignUpFail())));
                          }
                        }
                      },
                      height: 57,
                      width: 300,
                      textSize: 16,
                      color: Colors.blue[600],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
