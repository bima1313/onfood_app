import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.normal,
  });

  final String text;

  /// The thickness of the glyphs used to draw the text.
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: fontWeight,
      ),
    );
  }
}
