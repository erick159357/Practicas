import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unsplash_app/data/models/photo_model.dart';
import 'package:unsplash_app/domain/entities/photo.dart';
import 'package:unsplash_app/presentation/providers/providers.dart';
class FavoritesNotifier extends StateNotifier<List<Photo>> {
  final SharedPreferences _prefs;
  static const _key = 'favorite_photos';

  FavoritesNotifier(this._prefs) : super(const []) {
    _load();
  }

  void _load() {
    final str = _prefs.getString(_key);
    if (str == null) return;
    try {
      final list = jsonDecode(str) as List;
      state = list
          .map((j) => PhotoModel.fromCache(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      state = const [];
    }
  }

  bool isFavorite(String id) => state.any((p) => p.id == id);

  /// Agrega o quita un favorito y persiste el cambio.
  Future<void> toggle(Photo photo) async {
    if (isFavorite(photo.id)) {
      state = state.where((p) => p.id != photo.id).toList();
    } else {
      state = [...state, photo];
    }
    await _save();
  }

  Future<void> _save() async {
    final jsonList =
        state.map((p) => PhotoModel.fromEntity(p).toCache()).toList();
    await _prefs.setString(_key, jsonEncode(jsonList));
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Photo>>((ref) {
  return FavoritesNotifier(ref.watch(sharedPreferencesProvider));
});
