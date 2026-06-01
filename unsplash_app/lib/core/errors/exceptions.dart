/// Error al comunicarse con el servidor de la API .
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Error del servidor.']);
}

/// No hay conexión a internet.
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Sin conexion a internet.']);
}

/// Error al leer/escribir en el almacenamiento local (cache).
class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Error al acceder a los datos locales.']);
}

/// La Access Key de Unsplash no esta configurada o es invalida
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([
    this.message = 'Access Key invalida o no configurada. Revisa api_constants.dart.',
  ]);
}

/// Se alcanzo el límite de peticiones por hora de la API 
class RateLimitException implements Exception {
  final String message;
  RateLimitException([
    this.message = 'Se alcanzo el limite de peticiones por hora.',
  ]);
}
