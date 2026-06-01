import 'package:unsplash_app/domain/entities/photo.dart';
import 'package:unsplash_app/domain/repositories/photo_repository.dart';
class GetPhotos {
  final PhotoRepository _repository;

  GetPhotos(this._repository);

  Future<List<Photo>> call({required int page, required int perPage}) {
    return _repository.getPhotos(page: page, perPage: perPage);
  }
}
