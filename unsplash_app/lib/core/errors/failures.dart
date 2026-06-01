abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Falla por problemas del servidor.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ocurrio un error en el servidor. Intenta mas tarde.']);
}

/// Falla por falta de conexion.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No hay conexion a internet.']);
}

/// Falla al leer datos guardados localmente.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'No hay contenido guardado para mostrar sin conexion.']);
}

/// Falla por Access Key invalida o ausente.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'La Access Key de Unsplash no es valida.',
  ]);
}

/// Falla por alcanzar el límite de peticiones de la API.
class RateLimitFailure extends Failure {
  const RateLimitFailure([
    super.message =
        'Alcanzaste el limite de peticiones por hora de Unsplash. Espera unos minutos e intenta de nuevo.',
  ]);
}
