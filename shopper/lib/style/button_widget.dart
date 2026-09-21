import 'package:flutter/material.dart';

import 'text_widget.dart';
import 'app_constants.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double textSize;
  final Color? color;

  const ButtonWidget(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      required this.width,
      required this.height,
      required this.textSize,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 5,
                color: AppConstants.primaryColor.withOpacity(0.2))
          ]),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: color, elevation: 0),
          onPressed: () => onPressed(),
          child: TextWidget(
            txt: buttonText,
            fontSize: textSize,
            fontWeight: FontWeight.w700,
            textColor: AppConstants.whiteColor,
          )),
    );
  }
}
