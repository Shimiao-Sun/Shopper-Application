import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/text_widget.dart';
import '../style/button_widget.dart';

class ResetPasswordSuccess extends StatelessWidget {
  const ResetPasswordSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/success.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            const TextWidget(
              txt: "Reset Password Success!",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textColor: Colors.black,
            ),
            const SizedBox(height: 10),
            ButtonWidget(
              buttonText: "Login",
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName));
              },
              height: 57,
              width: 300,
              textSize: 16,
              color: Colors.orange,
            )
          ],
        )));
  }
}
