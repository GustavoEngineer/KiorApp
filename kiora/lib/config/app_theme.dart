import 'package:flutter/material.dart';

/// Clase que contiene las familias tipográficas de Kiora
class KioraTypography {
  // Esta clase no debe ser instanciada
  KioraTypography._();

  /// Fuente principal para títulos y encabezados
  static const String headlines = 'BricolageGrotesque';

  /// Fuente para el contenido y texto general
  static const String body = 'IBMPlexSans';
}

/// Clase que contiene la configuración del tema de Kiora
class KioraColors {
  // Esta clase no debe ser instanciada
  KioraColors._();

  /// Color de acento principal de Kiora
  /// Usado para: Acciones de Alta Prioridad (Botón Quick Add),
  /// Indicadores del Smart Sort, y Elementos interactivos
  static const accentKiora = Color(0xFF8184F8);

  /// Color de fondo en modo claro
  static const backgroundLight = Color(0xFFFFFFFF);

  /// Color de fondo en modo oscuro
  static const backgroundDark = Color(0xFF1E1E1E);

  /// Color de texto primario en modo claro
  /// Usado para: Títulos, Cuerpo de texto principal, y la mayoría de la iconografía
  static const textPrimaryLight = Color(0xFF000000);

  /// Color de texto primario en modo oscuro
  /// Usado para: Títulos, Cuerpo de texto principal, y la mayoría de la iconografía
  static const textPrimaryDark = Color(0xFFFFFFFF);

  /// Color de texto secundario
  /// Usado para: Fechas de vencimiento, descripciones opcionales, y etiquetas de categorías
  static const textSecondary = Color(0xFFA8A8A8);

  /// Color de éxito
  /// Usado para: Indicadores de tarea completada, mensajes de éxito,
  /// y gestos de deslizamiento (Swipe)
  static const success = Color(0xFF34C759);

  /// Color de alerta/advertencia
  /// Usado para: Tareas atrasadas, errores de sincronización,
  /// y acciones destructivas (Eliminar)
  static const alert = Color(0xFFFF3B30);
}

/// Configuración del tema claro de Kiora
final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF8184F8),
    background: KioraColors.backgroundLight,
    onBackground: KioraColors.textPrimaryLight,
    secondary: KioraColors.accentKiora,
    error: KioraColors.alert,
  ),
  scaffoldBackgroundColor: KioraColors.backgroundLight,
  textTheme: TextTheme(
    // Títulos principales
    displayLarge: const TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w800,
      color: KioraColors.textPrimaryLight,
    ),
    displayMedium: const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w800,
      color: KioraColors.textPrimaryLight,
    ),
    displaySmall: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: KioraColors.textPrimaryLight,
    ),
    // Encabezados
    headlineLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: KioraColors.textPrimaryLight,
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: KioraColors.textPrimaryLight,
    ),
    headlineSmall: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: KioraColors.textPrimaryLight,
    ),
    // Títulos de sección
    titleLarge: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: KioraColors.textPrimaryLight,
    ),
    // Contenido
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: KioraColors.textPrimaryLight,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: KioraColors.textPrimaryLight,
    ),
    bodySmall: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: KioraColors.textSecondary,
    ),
    // Etiquetas y metadata
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: KioraColors.textSecondary,
    ),
    labelMedium: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: KioraColors.textSecondary,
    ),
    labelSmall: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: KioraColors.textSecondary,
    ),
  ),
);
