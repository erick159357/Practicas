import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unsplash_app/core/constants/api_constants.dart';
import 'package:unsplash_app/core/errors/failures.dart';
import 'package:unsplash_app/domain/usecases/get_photos.dart';
import 'package:unsplash_app/presentation/providers/photo_list_state.dart';
import 'package:unsplash_app/presentation/providers/providers.dart';

/// Maneja el estado de la pantalla "Explorar" con paginación infinita.
class ExploreNotifier extends StateNotifier<PhotoListState> {
  final GetPhotos _getPhotos;

  ExploreNotifier(this._getPhotos) : super(const PhotoListState.loading()) {
    loadFirstPage();
  }

  int _page = 1;

  /// Carga (o recarga) la primera página.
  Future<void> loadFirstPage() async {
    _page = 1;
    state = const PhotoListState.loading();
    try {
      final photos =
          await _getPhotos(page: _page, perPage: ApiConstants.perPage);
      state = PhotoListState(
        photos: photos,
        hasReachedEnd: photos.length < ApiConstants.perPage,
      );
      _page++;
    } catch (e) {
      state = PhotoListState(failure: _toFailure(e));
    }
  }

  /// Carga la siguiente pagina al hacer scroll.
  Future<void> loadNextPage() async {
    if (state.isInitialLoading ||
        state.isLoadingMore ||
        state.hasReachedEnd) {
      return;
    }
    state = state.copyWith(isLoadingMore: true, clearFailure: true);
    try {
      final photos =
          await _getPhotos(page: _page, perPage: ApiConstants.perPage);
      state = state.copyWith(
        photos: [...state.photos, ...photos],
        isLoadingMore: false,
        hasReachedEnd: photos.length < ApiConstants.perPage,
      );
      _page++;
    } catch (e) {
      // un error no borra lo ya cargado: solo se reporta.
      state = state.copyWith(isLoadingMore: false, failure: _toFailure(e));
    }
  }

  Failure _toFailure(Object e) =>
      e is Failure ? e : ServerFailure(e.toString());
}

final exploreProvider =
    StateNotifierProvider<ExploreNotifier, PhotoListState>((ref) {
  return ExploreNotifier(ref.watch(getPhotosProvider));
});
