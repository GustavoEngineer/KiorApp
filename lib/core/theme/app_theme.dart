import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    // Usar fromSeed genera una paleta de colores completa y coherente.
    // Esto soluciona problemas de fondo negro en transiciones y diálogos.
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 157, 157, 228),
      brightness: Brightness.light,
      // Aseguramos que tanto el fondo como la superficie sean blancos.
      background: Colors.white,
    ),
    fontFamily: 'sans-serif',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontWeight: FontWeight.w300),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.05),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFA5C9FF).withOpacity(0.5),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w500),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color.fromARGB(255, 157, 157, 228),
      unselectedItemColor: Color(0xFF333333),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    ),
  );
}
