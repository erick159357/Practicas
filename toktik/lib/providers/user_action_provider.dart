import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserActionsProvider extends ChangeNotifier {
  static const _favoritesKey = 'favorites';

  final Set<String> _favorites = <String>{};
  final Set<String> _muted = <String>{};

  /// Carga los favoritos almacenados en SharedPreferences.
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_favoritesKey);
    if (stored != null) {
      _favorites.addAll(stored);
      notifyListeners();
    }
  }

  /// Guarda el Set actual de favoritos en SharedPreferences.
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favorites.toList());
  }

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    _saveFavorites(); // Persiste el cambio
    notifyListeners();
  }

  bool isMuted(String id) => _muted.contains(id);

  void toggleMute(String id) {
    if (_muted.contains(id)) {
      _muted.remove(id);
    } else {
      _muted.add(id);
    }
    notifyListeners();
  }
}
