class Photo {
  final String id;
  final String description;
  final String thumbUrl; // imagen pequeña (para la cuadrícula)
  final String regularUrl; // imagen mediana (para el detalle)
  final String fullUrl; // imagen grande (para descargar/ver)
  final String authorName;
  final String authorUsername;
  final String authorProfileUrl;
  final int width;
  final int height;
  final String color; 
  final String downloadLocation; 

  const Photo({
    required this.id,
    required this.description,
    required this.thumbUrl,
    required this.regularUrl,
    required this.fullUrl,
    required this.authorName,
    required this.authorUsername,
    required this.authorProfileUrl,
    required this.width,
    required this.height,
    required this.color,
    required this.downloadLocation,
  });

  /// Relacion de aspecto (ancho/alto).
  double get aspectRatio => width > 0 && height > 0 ? width / height : 1.0;
}
