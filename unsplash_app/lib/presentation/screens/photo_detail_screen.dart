import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unsplash_app/domain/entities/photo.dart';
import 'package:unsplash_app/presentation/providers/favorites_provider.dart';

/// Pantalla de detalle de una foto.
class PhotoDetailScreen extends ConsumerWidget {
  final Photo photo;

  const PhotoDetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((p) => p.id == photo.id);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(photo.authorName),
      ),
      body: Stack(
        children: [
          // Imagen a pantalla completa con zoom.
          Center(
            child: Hero(
              tag: 'photo_${photo.id}',
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: photo.regularUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 80,
                  ),
                ),
              ),
            ),
          ),
          // Panel inferior con atribución y descripción.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    photo.description,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Atribución obligatoria al fotógrafo y a Unsplash.
                  Row(
                    children: [
                      const Icon(Icons.camera_alt_outlined,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Foto de ${photo.authorName} en Unsplash',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Botón de favorito.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            ref.read(favoritesProvider.notifier).toggle(photo),
        backgroundColor: isFavorite ? Colors.red : Colors.white,
        foregroundColor: isFavorite ? Colors.white : Colors.black,
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        label: Text(isFavorite ? 'En favoritos' : 'Guardar'),
      ),
    );
  }
}
