import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final String fontType;
  const CustomText({
    super.key,
    required this.text,
    required this.fontType,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: (fontType == 'bold') ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
