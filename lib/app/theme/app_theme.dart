import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0E12),
      primaryColor: const Color(0xFF2F6BFF),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
          fontFamily: 'SF Pro Display',
        ),
        displayMedium: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
          fontFamily: 'SF Pro Display',
        ),
        labelMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9AA4B2),
          fontFamily: 'SF Pro Text',
        ),
        labelSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9AA4B2),
          fontFamily: 'SF Pro Text',
        ),
      ),
    );
  }
}
