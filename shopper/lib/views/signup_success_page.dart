import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopper/style/text_widget.dart';
import 'package:shopper/style/button_widget.dart';

class SignUpSuccess extends StatelessWidget {
  const SignUpSuccess({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          const SizedBox(
            height: 120,
          ),
          Image.asset(
            'assets/images/success.png',
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          const TextWidget(
            txt: "SignUp Success",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textColor: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonWidget(
            buttonText: "Back To Login Page",
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
      ),
    );
  }
}
