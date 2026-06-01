import 'package:unsplash_app/domain/entities/photo.dart';
import 'package:unsplash_app/domain/repositories/photo_repository.dart';

///uso: buscar fotos por palabra clave.
class SearchPhotos {
  final PhotoRepository _repository;

  SearchPhotos(this._repository);

  Future<List<Photo>> call({
    required String query,
    required int page,
    required int perPage,
  }) {
    return _repository.searchPhotos(query: query, page: page, perPage: perPage);
  }
}
