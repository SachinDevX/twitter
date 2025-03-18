import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 105, 105, 105),
    secondary: const Color.fromARGB(255, 30, 30, 30),
    tertiary: const Color.fromARGB(255, 47, 47, 47),
    surface: const Color.fromARGB(255, 20, 20, 20),
    inversePrimary: Colors.grey.shade300
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00FF85).withOpacity(0.2),
      foregroundColor: const Color(0xFF00FF85),
      padding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: const BorderSide(
        color: Color(0xFF00FF85),
        width: 2,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color(0xFF00FF85),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xFF00FF85).withOpacity(0.5),
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);