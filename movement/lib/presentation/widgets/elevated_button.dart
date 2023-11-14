import 'package:flutter/material.dart';

import '../../text_style.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String buttonText;
  final double screenWidth;
  final Color buttonColor;
  final VoidCallback? onPressed;
  final bool manualWidth;

  const ElevatedButtonWidget({
    required this.buttonText,
    required this.screenWidth,
    required this.buttonColor,
    required this.onPressed,
    this.manualWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: manualWidth ? null : screenWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          buttonText,
          style: textStyleAkko18,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ElevatedIconButtonWidget extends StatelessWidget {
  final String buttonText;
  final IconData iconData;
  final double screenWidth;
  final Color buttonColor;
  final VoidCallback? onPressed;
  final bool manualWidth;

  const ElevatedIconButtonWidget({
    required this.buttonText,
    required this.screenWidth,
    required this.buttonColor,
    required this.iconData,
    required this.onPressed,
    this.manualWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: manualWidth ? null : screenWidth,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(iconData),
        label: Text(
          buttonText,
          style: textStyleAkko18,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
