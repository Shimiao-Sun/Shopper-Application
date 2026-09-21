import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/text_widget.dart';
import '../style/button_widget.dart';

class GenericPasswordResetError extends StatelessWidget {
  const GenericPasswordResetError({Key? key}) : super(key: key);

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
              'assets/images/fail.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            const TextWidget(
              txt: "Password Reset Failed",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textColor: Colors.red,
            ),
            const SizedBox(height: 12),
            const TextWidget(
              txt: "Something went wrong on our side.",
              fontSize: 17,
              fontWeight: FontWeight.bold,
              textColor: Colors.red,
            ),
            const TextWidget(
              txt: "Please try again.",
              fontSize: 17,
              fontWeight: FontWeight.bold,
              textColor: Colors.red,
            ),
            const SizedBox(height: 10),
            ButtonWidget(
              buttonText: "Try Again",
              onPressed: () {
                Navigator.pop(context);
              },
              height: 57,
              width: 300,
              textSize: 16,
              color: const Color.fromARGB(255, 241, 106, 43),
            )
          ],
        )));
  }
}
