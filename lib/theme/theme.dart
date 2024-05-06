import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF006D5B), // Your existing primary color
    secondary: const Color.fromARGB(
        255, 88, 50, 155), // Deep Purple as the new secondary color
    background: const Color(0xFFFDF5E6),
    onBackground: const Color(0xFF36454F),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color.fromARGB(
        255, 104, 58, 183), // Using Deep Purple for buttons as well
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFFFFFFFF)),
    bodyLarge: TextStyle(color: Color(0xFF36454F)),
  ),
);
