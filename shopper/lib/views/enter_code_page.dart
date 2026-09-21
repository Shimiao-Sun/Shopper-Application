import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/style/text_form_field_widget.dart';
import 'package:shopper/views/enter_code_invalid_code_page.dart';
import 'package:shopper/views/enter_code_not_found_page.dart';
import 'package:shopper/views/forgot_password_fail_generic.dart';
import 'package:shopper/views/reset_password_page.dart';

import '../style/text_widget.dart';
import '../style/app_constants.dart';
import '../style/button_widget.dart';
import '../viewmodels/authentication_viewmodel.dart';

class EnterCode extends StatefulWidget {
  const EnterCode({Key? key}) : super(key: key);

  @override
  State<EnterCode> createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    int verificationCode = -1;
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
                              txt: "Enter Code",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: AppConstants.titleTextColor,
                            ),
                            const SizedBox(height: 8),
                            const TextWidget(
                              txt:
                                  "A code has been sent to your email address.",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppConstants.subTxtColor,
                            ),
                            const TextWidget(
                              txt: "Please enter the code below.",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppConstants.subTxtColor,
                            ),
                            const SizedBox(height: 24),
                            TextFormFieldWidget(
                              hintText: "Verification Code",
                              minLines: 1,
                              maxLines: 1,
                              prefixIcon: const Icon(Icons.lock_outline),
                              isPasswordField: false,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Enter your Verification Code";
                                }
                                if (RegExp(r"^[0-9]*$").hasMatch(val) ==
                                    false) {
                                  return "Please enter only numbers";
                                }
                                verificationCode = int.parse(val);
                              },
                            ),
                            const SizedBox(height: 16),
                            ButtonWidget(
                                buttonText: "Validate Code",
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    int validateSuccess = await authViewModel
                                        .checkResetCode(verificationCode);

                                    if (validateSuccess == 0) {
                                      //Success
                                      await authViewModel
                                          .setCodeUsed(verificationCode);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ResetPassword()));
                                    } else if (validateSuccess == 1) {
                                      // Code not found
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CodeNotFound()));
                                    } else if (validateSuccess == 2) {
                                      // Code has been used or is expired
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const InvalidCode()));
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
                                color: Colors.blue[600])
                          ],
                        ))))));
  }
}
