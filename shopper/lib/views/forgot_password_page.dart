import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:shopper/models/account.dart';
import 'package:shopper/style/app_constants.dart';
import 'package:shopper/viewmodels/authentication_viewmodel.dart';
import 'package:shopper/views/forgot_password_fail_generic.dart';
import 'package:shopper/views/forgot_password_fail_email_not_found_page.dart';

import '../style/text_form_field_widget.dart';
import '../style/text_widget.dart';
import '../style/button_widget.dart';
import 'enter_code_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String email = "";
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
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo/shopper.png',
                            ),
                            const SizedBox(height: 16),
                            const TextWidget(
                              txt: "Forgot Password",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: AppConstants.titleTextColor,
                            ),
                            const SizedBox(height: 8),
                            const TextWidget(
                              txt: "Please enter your Email Address.",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppConstants.subTxtColor,
                            ),
                            const TextWidget(
                              txt: "You will receive an email with a code",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppConstants.subTxtColor,
                            ),
                            const TextWidget(
                              txt: "which can be used to reset your password.",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppConstants.subTxtColor,
                            ),
                            const SizedBox(height: 24),
                            TextFormFieldWidget(
                              hintText: "Email",
                              minLines: 1,
                              maxLines: 1,
                              prefixIcon: const Icon(Icons.email_outlined),
                              isPasswordField: false,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Enter your Email";
                                }
                                if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val) ==
                                    false) {
                                  return "Please enter an email";
                                }
                                email = val;
                              },
                            ),
                            const SizedBox(height: 16),
                            ButtonWidget(
                                buttonText: "Send Email",
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (await authViewModel.findUser(email)) {
                                      Account.user.email = email;

                                      // Generate code for security purposes
                                      Random randomNumberGenerator = Random();
                                      int verificationCode =
                                          randomNumberGenerator
                                                  .nextInt(900000) +
                                              100000;

                                      // Set Expiration Date/Time to be 24hours past current time
                                      DateTime currentDateTime = DateTime.now();
                                      DateTime expirationDateTime = DateTime(
                                          currentDateTime.year,
                                          currentDateTime.month,
                                          currentDateTime.day + 1,
                                          currentDateTime.hour,
                                          currentDateTime.minute,
                                          currentDateTime.second,
                                          currentDateTime.millisecond,
                                          currentDateTime.microsecond);

                                      // Store Verification Code and DateTime in Database
                                      bool codeStorageSuccess =
                                          await authViewModel.storeResetCode(
                                              Account.user.email,
                                              verificationCode,
                                              expirationDateTime.toString());

                                      if (!codeStorageSuccess) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const GenericPasswordResetError()));
                                      }

                                      String apiKey = await authViewModel
                                          .getApiKey("SendGrid");
                                      if (apiKey == "") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const GenericPasswordResetError()));
                                      }

                                      await authViewModel.checkInfo();
                                      final mailer = Mailer(apiKey);
                                      final toAddress =
                                          Address(Account.user.email);
                                      final fromAddress = Address(authViewModel
                                          .passwordResetEmailSender);
                                      final content = Content('text/plain',
                                          'Hi ${Account.user.firstName},\n\nThe following is your password reset code:\n\n${verificationCode.toString()}\n\nPlease do not share this code with anyone.\n\nIf you did not request this email, please reset your password immediately.\n\nFrom,\nThe Shopper Team.');
                                      const subject = 'Forgot Password';
                                      final personalisation =
                                          Personalization([toAddress]);

                                      final resetPasswordEmail = Email(
                                          [personalisation],
                                          fromAddress,
                                          subject,
                                          content: [content]);

                                      mailer.send(resetPasswordEmail);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EnterCode()));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EmailNotFound()));
                                    }
                                  }
                                },
                                height: 57,
                                width: 300,
                                textSize: 16,
                                color: Colors.blue[600])
                          ],
                        ))))));
  }
}
