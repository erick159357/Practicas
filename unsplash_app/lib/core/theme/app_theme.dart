import 'package:flutter/material.dart';
/// Definición de los temas claro y oscuro de la aplicación.
class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF3D5AFE); 

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    appBarTheme: const AppBarTheme(centerTitle: false),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0E0E12),
    appBarTheme: const AppBarTheme(centerTitle: false),
  );
}
