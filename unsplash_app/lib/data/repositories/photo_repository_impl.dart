import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unsplash_app/core/errors/exceptions.dart';
import 'package:unsplash_app/core/errors/failures.dart';
import 'package:unsplash_app/core/network/network_info.dart';
import 'package:unsplash_app/data/datasources/unsplash_remote_datasource.dart';
import 'package:unsplash_app/data/models/photo_model.dart';
import 'package:unsplash_app/domain/entities/photo.dart';
import 'package:unsplash_app/domain/repositories/photo_repository.dart';
class PhotoRepositoryImpl implements PhotoRepository {
  final UnsplashRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  final SharedPreferences _prefs;

  static const _cacheKey = 'cached_explore_photos';

  PhotoRepositoryImpl({
    required UnsplashRemoteDataSource remote,
    required NetworkInfo networkInfo,
    required SharedPreferences prefs,
  })  : _remote = remote,
        _networkInfo = networkInfo,
        _prefs = prefs;

  @override
  Future<List<Photo>> getPhotos({
    required int page,
    required int perPage,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final photos = await _remote.getPhotos(page: page, perPage: perPage);
        // se guarda solo la primera pagina para mostrar algo sin conexion.
        if (page == 1) {
          await _cachePhotos(photos);
        }
        return photos;
      } on UnauthorizedException catch (e) {
        throw UnauthorizedFailure(e.message);
      } on RateLimitException catch (e) {
        throw RateLimitFailure(e.message);
      } on NetworkException {
        return _fallbackToCache(page);
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      }
    } else {
      // Sin conexión: intentamos servir el cache.
      return _fallbackToCache(page);
    }
  }

  @override
  Future<List<Photo>> searchPhotos({
    required String query,
    required int page,
    required int perPage,
  }) async {
    if (!await _networkInfo.isConnected) {
      // si requiere internet (no la cacheamos).
      throw const NetworkFailure('La búsqueda necesita conexión a internet.');
    }
    try {
      return await _remote.searchPhotos(
        query: query,
        page: page,
        perPage: perPage,
      );
    } on UnauthorizedException catch (e) {
      throw UnauthorizedFailure(e.message);
    } on RateLimitException catch (e) {
      throw RateLimitFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  // ─── Manejo de cache ────

  Future<List<Photo>> _fallbackToCache(int page) async {
    if (page == 1) {
      final cached = _getCachedPhotos();
      if (cached.isNotEmpty) return cached;
    }
    throw const NetworkFailure();
  }

  Future<void> _cachePhotos(List<PhotoModel> photos) async {
    try {
      final jsonList = photos.map((p) => p.toCache()).toList();
      await _prefs.setString(_cacheKey, jsonEncode(jsonList));
    } catch (_) {
    }
  }

  List<Photo> _getCachedPhotos() {
    final str = _prefs.getString(_cacheKey);
    if (str == null) return [];
    try {
      final list = jsonDecode(str) as List;
      return list
          .map((j) => PhotoModel.fromCache(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
