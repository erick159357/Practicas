import 'package:unsplash_app/core/errors/failures.dart';
import 'package:unsplash_app/domain/entities/photo.dart';
class PhotoListState {
  /// Fotos acumuladas hasta ahora.
  final List<Photo> photos;

  /// Cargando la primera página 
  final bool isInitialLoading;

  /// Cargando una página adicional 
  final bool isLoadingMore;

  /// Ya no hay más páginas que pedir.
  final bool hasReachedEnd;

  /// Falla actual  para mostrar mensaje al usuario.
  final Failure? failure;

  const PhotoListState({
    this.photos = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.failure,
  });

  /// Estado inicial vacío (sin cargar nada todavía).
  const PhotoListState.idle() : this();

  /// Estado inicial cargando la primera página.
  const PhotoListState.loading() : this(isInitialLoading: true);

  bool get isEmpty => photos.isEmpty;

  PhotoListState copyWith({
    List<Photo>? photos,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return PhotoListState(
      photos: photos ?? this.photos,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
