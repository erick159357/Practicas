import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unsplash_app/core/constants/api_constants.dart';
import 'package:unsplash_app/core/network/network_info.dart';
import 'package:unsplash_app/data/datasources/unsplash_remote_datasource.dart';
import 'package:unsplash_app/data/repositories/photo_repository_impl.dart';
import 'package:unsplash_app/domain/repositories/photo_repository.dart';
import 'package:unsplash_app/domain/usecases/get_photos.dart';
import 'package:unsplash_app/domain/usecases/search_photos.dart';
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider debe sobrescribirse en main()');
});
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      headers: {
        'Authorization': 'Client-ID ${ApiConstants.accessKey}',
        'Accept-Version': 'v1',
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
});

/// Plugin de conectividad.
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

/// Stream que emite cambios de conexión.
final connectivityStreamProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  return ref.watch(connectivityProvider).onConnectivityChanged;
});

/// Abstracción de red.
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
});

/// Datasource remoto.
final remoteDataSourceProvider = Provider<UnsplashRemoteDataSource>((ref) {
  return UnsplashRemoteDataSourceImpl(ref.watch(dioProvider));
});

final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepositoryImpl(
    remote: ref.watch(remoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

/// Casos de uso.
final getPhotosProvider = Provider<GetPhotos>((ref) {
  return GetPhotos(ref.watch(photoRepositoryProvider));
});

final searchPhotosProvider = Provider<SearchPhotos>((ref) {
  return SearchPhotos(ref.watch(photoRepositoryProvider));
});
