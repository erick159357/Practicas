import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_app/domain/entities/photo.dart';

/// Tarjeta individual de una foto para la cuadrícula.
/// Usa CachedNetworkImage para cachear la imagen en disco (clave para que se vea offline)
class PhotoCard extends StatelessWidget {
  final Photo photo;
  final VoidCallback onTap;

  const PhotoCard({super.key, required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: photo.aspectRatio,
          child: Hero(
            tag: 'photo_${photo.id}',
            child: CachedNetworkImage(
              imageUrl: photo.thumbUrl,
              fit: BoxFit.cover,
              // Mientras carga, mostramos el color dominante de la foto.
              placeholder: (context, url) => Container(color: _hexToColor(photo.color)),
              errorWidget: (context, url, error) => Container(
                color: _hexToColor(photo.color),
                child: const Icon(Icons.broken_image, color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Convierte un color hex de Unsplash (#RRGGBB) a un Color de Flutter.
  Color _hexToColor(String hex) {
    try {
      final cleaned = hex.replaceFirst('#', '');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return Colors.grey.shade300;
    }
  }
}
