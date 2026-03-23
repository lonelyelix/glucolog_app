import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkGreen = Color(0xFF075F0D);
  static const Color lightGreen = Color(0xFFC2D85E);
  static const Color cream = Color(0xFFF2EED2);
  static const Color softGreenCard = Color(0xFFA9DD79);
  static const Color graphGreen = Color(0xFF67BF61);
  static const Color supportYellow = Color(0xFFE8E26D);
  static const Color textDark = Color(0xFF1A1A1A);

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: lightGreen,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkGreen,
      primary: darkGreen,
      secondary: lightGreen,
      surface: cream,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightGreen,
      foregroundColor: darkGreen,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: darkGreen, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightGreen,
        foregroundColor: darkGreen,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cream,
      selectedItemColor: darkGreen,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}