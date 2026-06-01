import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unsplash_app/presentation/providers/providers.dart';

/// Maneja el modo de tema (claro / oscuro / sistema) y lo persiste con 
/// SharedPreferences para que se conserve entre ejecuciones de la app.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _key = 'theme_mode';

  ThemeNotifier(this._prefs) : super(ThemeMode.system) {
    _load();
  }

  void _load() {
    final saved = _prefs.getString(_key);
    state = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Alterna entre claro y oscuro.
  Future<void> toggle() async {
    // Si está en "sistema", tomamos como referencia el claro para alternar.
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setMode(next);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_key, mode.name);
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(sharedPreferencesProvider));
});
