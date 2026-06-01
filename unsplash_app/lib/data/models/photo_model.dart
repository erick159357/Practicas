import 'package:unsplash_app/domain/entities/photo.dart';
class PhotoModel extends Photo {
  const PhotoModel({
    required super.id,
    required super.description,
    required super.thumbUrl,
    required super.regularUrl,
    required super.fullUrl,
    required super.authorName,
    required super.authorUsername,
    required super.authorProfileUrl,
    required super.width,
    required super.height,
    required super.color,
    required super.downloadLocation,
  });
  factory PhotoModel.fromApi(Map<String, dynamic> json) {
    final urls = json['urls'] as Map<String, dynamic>? ?? {};
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final userLinks = user['links'] as Map<String, dynamic>? ?? {};
    final links = json['links'] as Map<String, dynamic>? ?? {};

    return PhotoModel(
      id: json['id'] as String? ?? '',
      description: (json['description'] ??
              json['alt_description'] ??
              'Sin descripción') as String,
      thumbUrl: urls['small'] as String? ?? '',
      regularUrl: urls['regular'] as String? ?? '',
      fullUrl: urls['full'] as String? ?? '',
      authorName: user['name'] as String? ?? 'Desconocido',
      authorUsername: user['username'] as String? ?? '',
      authorProfileUrl: userLinks['html'] as String? ?? '',
      width: json['width'] as int? ?? 1,
      height: json['height'] as int? ?? 1,
      color: json['color'] as String? ?? '#CCCCCC',
      downloadLocation: links['download_location'] as String? ?? '',
    );
  }

  /// Convierte el modelo a un mapa plano para guardarlo en SharedPreferences.
  Map<String, dynamic> toCache() => {
        'id': id,
        'description': description,
        'thumbUrl': thumbUrl,
        'regularUrl': regularUrl,
        'fullUrl': fullUrl,
        'authorName': authorName,
        'authorUsername': authorUsername,
        'authorProfileUrl': authorProfileUrl,
        'width': width,
        'height': height,
        'color': color,
        'downloadLocation': downloadLocation,
      };

  /// Reconstruye el modelo desde el mapa plano guardado en cache.
  factory PhotoModel.fromCache(Map<String, dynamic> json) => PhotoModel(
        id: json['id'] as String,
        description: json['description'] as String,
        thumbUrl: json['thumbUrl'] as String,
        regularUrl: json['regularUrl'] as String,
        fullUrl: json['fullUrl'] as String,
        authorName: json['authorName'] as String,
        authorUsername: json['authorUsername'] as String,
        authorProfileUrl: json['authorProfileUrl'] as String,
        width: json['width'] as int,
        height: json['height'] as int,
        color: json['color'] as String,
        downloadLocation: json['downloadLocation'] as String,
      );

  /// Crea un PhotoModel a partir de una entidad Photo (para serializar favoritos que llegan como entidades del dominio).
  factory PhotoModel.fromEntity(Photo p) => PhotoModel(
        id: p.id,
        description: p.description,
        thumbUrl: p.thumbUrl,
        regularUrl: p.regularUrl,
        fullUrl: p.fullUrl,
        authorName: p.authorName,
        authorUsername: p.authorUsername,
        authorProfileUrl: p.authorProfileUrl,
        width: p.width,
        height: p.height,
        color: p.color,
        downloadLocation: p.downloadLocation,
      );
}
