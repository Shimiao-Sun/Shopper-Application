import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/text_widget.dart';
import '../style/button_widget.dart';

class InvalidCode extends StatelessWidget {
  const InvalidCode({Key? key}) : super(key: key);

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
                statusBarBrightness: Brightness.light)),
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/fail.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const TextWidget(
              txt: "Code Validation Failed",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textColor: Colors.red,
            ),
            const SizedBox(height: 8),
            const TextWidget(
              txt: "The code you entered has either",
              fontSize: 17,
              fontWeight: FontWeight.bold,
              textColor: Colors.red,
            ),
            const TextWidget(
              txt: " expired, or has been used previously.",
              fontSize: 17,
              fontWeight: FontWeight.bold,
              textColor: Colors.red,
            ),
            const TextWidget(
              txt: "Please generate a new code.",
              fontSize: 17,
              fontWeight: FontWeight.bold,
              textColor: Colors.red,
            ),
            const SizedBox(height: 10),
            ButtonWidget(
              buttonText: "Try Again",
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
        )));
  }
}
