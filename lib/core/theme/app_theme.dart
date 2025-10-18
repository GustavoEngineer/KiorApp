import 'package:flutter/material.dart';

// 1. Constantes de Color
const Color kPrimaryColor = Color(0xFF3476E6);
const Color kScaffoldBackgroundColor = Color(0xFFFFFFFF);
const Color kCardColor = Color(0xFFFFFFFF);
const Color kTextColorPrimary = Color(0xFF000000);
const Color kTextColorSecondary = Color(0xFF333333);
const Color kTextColorDetail = Color(0xFFA9A9A9);
const Color kHighlightColor = Color(0xFF5993FF);

// 2. Base del Tema
ThemeData get baseTheme {
  const textTheme = TextTheme(
    headlineLarge: TextStyle(color: kTextColorPrimary),
    titleLarge: TextStyle(color: kTextColorPrimary),
    bodyMedium: TextStyle(color: kTextColorSecondary),
    bodySmall: TextStyle(color: kTextColorDetail),
  );

  return ThemeData(
      fontFamily: 'Outfit',
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: kScaffoldBackgroundColor,
      cardColor: kCardColor,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: kScaffoldBackgroundColor,
        elevation: 0.0,
        foregroundColor: kTextColorPrimary,
      ),

      // FloatingActionButton Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),

      // Text Theme
      textTheme: textTheme,

      iconTheme: const IconThemeData(color: kTextColorSecondary),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: kScaffoldBackgroundColor.withOpacity(0.5),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ));
}