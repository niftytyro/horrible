import 'package:flutter/material.dart';

class BrickColors {
  static const Color orchidCrayoia = Color(0xFFFFB2E6);
  static const Color darkLiver = Color(0xFF483C46);
  static const Color vividViolet = Color(0xFF8447FF);
  static const Color aquamarince = Color(0xFF8CFFDA);
}

class BrickTheme {
  static ThemeData get lightTheme {
    return ThemeData(fontFamily: 'Raleway');
  }

  static TextTheme get textTheme {
    return const TextTheme(
      bodyText1: TextStyle(fontSize: 14),
      headline1: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }
}
