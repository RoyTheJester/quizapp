import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

var appTheme = ThemeData(
  fontFamily: GoogleFonts.ubuntu().fontFamily,
  appBarTheme: const AppBarTheme(color: Color.fromRGBO(65, 65, 65, 1)),
  bottomAppBarTheme: const BottomAppBarTheme(color: Color.fromRGBO(0, 0, 0, 1)),
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    labelLarge: TextStyle(
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleMedium: TextStyle(fontSize: 14, color: Colors.grey),
  ),
  buttonTheme: const ButtonThemeData(),
);
