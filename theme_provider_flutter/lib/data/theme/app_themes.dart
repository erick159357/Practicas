import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
    ),
  );


  static final ThemeData protanopia = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Georgia',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0072B2), // Azul Wong
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF0072B2),
      onPrimary: Colors.white,
      secondary: const Color(0xFFE69F00), // Naranja Wong
      onSecondary: Colors.black,
      tertiary: const Color(0xFFF0E442),  // Amarillo Wong
      onTertiary: Colors.black,
      error: const Color(0xFF6A3D9A),     // Morado (en lugar de rojo)
      onError: Colors.white,
      surface: const Color(0xFFFAF3E0),   // Crema cálido
      onSurface: const Color(0xFF1A1A1A),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 0.2),
      headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.2),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 17, letterSpacing: 0.3, height: 1.4),
      bodyMedium: TextStyle(fontSize: 15, letterSpacing: 0.3, height: 1.4),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 4,
    ),
  );


  static final ThemeData deuteranopia = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Verdana',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF56B4E9), // Azul cielo Wong
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF56B4E9),
      onPrimary: Colors.black,
      secondary: const Color(0xFFD55E00), // Bermellón Wong
      onSecondary: Colors.white,
      tertiary: const Color(0xFFCC79A7),  // Rosa rojizo
      onTertiary: Colors.white,
      error: const Color(0xFF1F4E79),     // Azul oscuro (evita rojo/verde)
      onError: Colors.white,
      surface: const Color(0xFFF5F5F5),
      onSurface: const Color(0xFF212121),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      headlineMedium: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 0.4),
      titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.4, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.4, height: 1.5),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.5),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 4,
    ),
  );

  static final ThemeData tritanopia = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Courier New',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD55E00), // Bermellón
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFFD55E00),   // Rojo/bermellón intenso
      onPrimary: Colors.white,
      secondary: const Color(0xFF009E73), // Verde azulado Wong
      onSecondary: Colors.white,
      tertiary: const Color(0xFFCC79A7),  // Rosa magenta
      onTertiary: Colors.white,
      error: const Color(0xFF990000),     // Rojo oscuro (el rojo sí se distingue)
      onError: Colors.white,
      surface: const Color(0xFFFFF5F5),   // Rosa muy pálido
      onSurface: const Color(0xFF1A0000),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1.0),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.8),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.0),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 0.8),
      bodyLarge: TextStyle(fontSize: 16, letterSpacing: 0.8, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.8, height: 1.5),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.0),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 4,
    ),
  );
}
