
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF8F8F8),
    primaryColor: const Color.fromARGB(255, 157, 157, 228),
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 157, 157, 228),
      secondary: Color(0xFFA5C9FF),
      background: Color(0xFFF8F8F8),
      onBackground: Color(0xFF333333),
      surface: Color(0xFFF8F8F8),
    ),
    fontFamily: 'sans-serif',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontWeight: FontWeight.w300),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.05),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFF8F8F8),
      indicatorColor: const Color(0xFFA5C9FF).withOpacity(0.5),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          color: Color(0xFF333333),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF8F8F8),
      selectedItemColor: Color.fromARGB(255, 157, 157, 228),
      unselectedItemColor: Color(0xFF333333),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    ),
  );
}
