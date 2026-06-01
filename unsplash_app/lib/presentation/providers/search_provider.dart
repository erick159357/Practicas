import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unsplash_app/core/constants/api_constants.dart';
import 'package:unsplash_app/core/errors/failures.dart';
import 'package:unsplash_app/domain/usecases/search_photos.dart';
import 'package:unsplash_app/presentation/providers/photo_list_state.dart';
import 'package:unsplash_app/presentation/providers/providers.dart';

/// Maneja el estado de la pantalla "Buscar": búsqueda por palabra clave
class SearchNotifier extends StateNotifier<PhotoListState> {
  final SearchPhotos _searchPhotos;

  // Estado inicial: vacio (aun no se ha buscado nada).
  SearchNotifier(this._searchPhotos) : super(const PhotoListState.idle());

  String _query = '';
  int _page = 1;

  String get query => _query;

  /// Inicia una nueva busqueda desde cero.
  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    _query = trimmed;
    _page = 1;
    state = const PhotoListState.loading();
    try {
      final photos = await _searchPhotos(
        query: _query,
        page: _page,
        perPage: ApiConstants.perPage,
      );
      state = PhotoListState(
        photos: photos,
        hasReachedEnd: photos.length < ApiConstants.perPage,
      );
      _page++;
    } catch (e) {
      state = PhotoListState(failure: _toFailure(e));
    }
  }

  /// Carga la siguiente página de la busqueda actual.
  Future<void> loadNextPage() async {
    if (_query.isEmpty ||
        state.isInitialLoading ||
        state.isLoadingMore ||
        state.hasReachedEnd) {
      return;
    }
    state = state.copyWith(isLoadingMore: true, clearFailure: true);
    try {
      final photos = await _searchPhotos(
        query: _query,
        page: _page,
        perPage: ApiConstants.perPage,
      );
      state = state.copyWith(
        photos: [...state.photos, ...photos],
        isLoadingMore: false,
        hasReachedEnd: photos.length < ApiConstants.perPage,
      );
      _page++;
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, failure: _toFailure(e));
    }
  }

  /// Limpia la busqueda y vuelve al estado inicial.
  void clear() {
    _query = '';
    _page = 1;
    state = const PhotoListState.idle();
  }

  Failure _toFailure(Object e) =>
      e is Failure ? e : ServerFailure(e.toString());
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, PhotoListState>((ref) {
  return SearchNotifier(ref.watch(searchPhotosProvider));
});
