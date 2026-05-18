import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

/// Tipos de tema disponibles en la aplicación.
enum AppThemeType {
  system,
  light,
  dark,
  protanopia,
  deuteranopia,
  tritanopia,
}

/// Extensión con metadatos de presentación para cada tipo de tema.
extension AppThemeTypeX on AppThemeType {
  String get label {
    switch (this) {
      case AppThemeType.system:
        return 'Automático (Sistema)';
      case AppThemeType.light:
        return 'Claro';
      case AppThemeType.dark:
        return 'Oscuro';
      case AppThemeType.protanopia:
        return 'Protanopía';
      case AppThemeType.deuteranopia:
        return 'Deuteranopía';
      case AppThemeType.tritanopia:
        return 'Tritanopía';
    }
  }

  String get description {
    switch (this) {
      case AppThemeType.system:
        return 'Sigue la configuración del dispositivo';
      case AppThemeType.light:
        return 'Tema claro estándar';
      case AppThemeType.dark:
        return 'Tema oscuro estándar';
      case AppThemeType.protanopia:
        return 'Accesible para dificultad con el rojo';
      case AppThemeType.deuteranopia:
        return 'Accesible para dificultad con el verde';
      case AppThemeType.tritanopia:
        return 'Accesible para dificultad con el azul';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeType.system:
        return Icons.brightness_auto;
      case AppThemeType.light:
        return Icons.light_mode;
      case AppThemeType.dark:
        return Icons.dark_mode;
      case AppThemeType.protanopia:
        return Icons.accessibility_new;
      case AppThemeType.deuteranopia:
        return Icons.remove_red_eye;
      case AppThemeType.tritanopia:
        return Icons.visibility;
    }
  }
}

class ThemeNotifier extends ChangeNotifier {
  static const _prefKey = 'appThemeType';

  AppThemeType _currentType = AppThemeType.system;

  AppThemeType get currentType => _currentType;

  ThemeMode get themeMode {
    switch (_currentType) {
      case AppThemeType.system:
        return ThemeMode.system;
      case AppThemeType.dark:
        return ThemeMode.dark;
      case AppThemeType.light:
      case AppThemeType.protanopia:
      case AppThemeType.deuteranopia:
      case AppThemeType.tritanopia:
        return ThemeMode.light;
    }
  }

  ThemeData get lightTheme {
    switch (_currentType) {
      case AppThemeType.protanopia:
        return AppThemes.protanopia;
      case AppThemeType.deuteranopia:
        return AppThemes.deuteranopia;
      case AppThemeType.tritanopia:
        return AppThemes.tritanopia;
      case AppThemeType.system:
      case AppThemeType.light:
      case AppThemeType.dark:
        return AppThemes.light;
    }
  }

  ThemeData get darkTheme => AppThemes.dark;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved != null) {
      try {
        _currentType = AppThemeType.values.firstWhere((t) => t.name == saved);
      } catch (_) {
        
        _currentType = AppThemeType.system;
      }
    }
    notifyListeners();
  }

  Future<void> setTheme(AppThemeType type) async {
    if (_currentType == type) return;
    _currentType = type;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, type.name);
  }
}
