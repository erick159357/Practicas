import 'package:unsplash_app/domain/entities/photo.dart';
abstract class PhotoRepository {
  /// Obtiene un listado paginado de fotos (explorar).
  Future<List<Photo>> getPhotos({required int page, required int perPage});

  /// Busca fotos por palabra clave, de forma paginada.
  Future<List<Photo>> searchPhotos({
    required String query,
    required int page,
    required int perPage,
  });
}
