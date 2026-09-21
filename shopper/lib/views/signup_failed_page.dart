import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopper/style/text_widget.dart';
import 'package:shopper/style/button_widget.dart';

class SignUpFail extends StatelessWidget {
  const SignUpFail({Key? key}) : super(key: key);

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
              const SizedBox(
                height: 120,
              ),
              Image.asset(
                'assets/images/fail.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12),
              const TextWidget(
                txt: "SignUp Failed",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textColor: Colors.red,
              ),
              const SizedBox(height: 12),
              const TextWidget(
                txt: "The email you used already exists!",
                fontSize: 17,
                fontWeight: FontWeight.bold,
                textColor: Colors.red,
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
                color: const Color.fromARGB(255, 241, 106, 43),
              )
            ],
          ),
        ));
  }
}
