import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/style/text_form_field_widget.dart';
import 'package:shopper/views/forgot_password_fail_generic.dart';
import 'package:shopper/views/reset_password_success_page.dart';

import '../models/account.dart';
import '../style/text_widget.dart';
import '../style/app_constants.dart';
import '../style/button_widget.dart';
import '../viewmodels/authentication_viewmodel.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
                    padding:
                        const EdgeInsets.only(top: 50, right: 16, left: 16),
                    child: Form(
                        key: formKey,
                        child: Column(children: [
                          Image.asset(
                            'assets/images/logo/shopper.png',
                          ),
                          const SizedBox(height: 16),
                          const TextWidget(
                            txt: "Reset Password",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            textColor: AppConstants.titleTextColor,
                          ),
                          const SizedBox(height: 8),
                          const TextWidget(
                            txt: "Please enter your new password below.",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: AppConstants.subTxtColor,
                          ),
                          const SizedBox(height: 24),
                          TextFormFieldWidget(
                              hintText: "Password",
                              minLines: 1,
                              maxLines: 1,
                              prefixIcon: const Icon(Icons.lock_outline),
                              isPasswordField: true,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Enter your new password";
                                } else {
                                  Account.user.password = val;
                                }
                              }),
                          const SizedBox(height: 13),
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
                              if (val != Account.user.password) {
                                return "Passwords do not match!";
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          ButtonWidget(
                            buttonText: "Reset Password",
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                Account.user.hashPassword();
                                bool resetSuccess =
                                    await authViewModel.resetPassword(
                                        Account.user.email,
                                        Account.user.password);

                                if (!mounted) return;

                                if (resetSuccess) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ResetPasswordSuccess()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const GenericPasswordResetError()));
                                }
                              }
                            },
                            height: 57,
                            width: 300,
                            textSize: 16,
                            color: Colors.blue[600],
                          )
                        ]))))));
  }
}
