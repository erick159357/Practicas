import 'package:dio/dio.dart';
import 'package:unsplash_app/core/constants/api_constants.dart';
import 'package:unsplash_app/core/errors/exceptions.dart';
import 'package:unsplash_app/data/models/photo_model.dart';

abstract class UnsplashRemoteDataSource {
  Future<List<PhotoModel>> getPhotos({required int page, required int perPage});
  Future<List<PhotoModel>> searchPhotos({
    required String query,
    required int page,
    required int perPage,
  });
}
class UnsplashRemoteDataSourceImpl implements UnsplashRemoteDataSource {
  final Dio _dio;

  UnsplashRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PhotoModel>> getPhotos({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/photos',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final list = response.data as List;
      return list
          .map((json) => PhotoModel.fromApi(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<List<PhotoModel>> searchPhotos({
    required String query,
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/search/photos',
        queryParameters: {'query': query, 'page': page, 'per_page': perPage},
      );
      // El endpoint de busqueda devuelve { total, total_pages, results: [...] }
      final results = response.data['results'] as List;
      return results
          .map((json) => PhotoModel.fromApi(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Traduce los errores de Dio a las excepciones de dominio.
  Exception _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401) {
      // Key inválida o no configurada.
      return UnauthorizedException();
    }
    if (status == 403) {
      // **El 403 significa que se agoto el limite de peticiones**
      return RateLimitException();
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException();
    }
    return ServerException('Error ${status ?? ''}: ${e.message ?? 'desconocido'}');
  }
}
