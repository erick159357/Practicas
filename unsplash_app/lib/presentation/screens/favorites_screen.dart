import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_app/presentation/providers/favorites_provider.dart';
import 'package:unsplash_app/presentation/screens/photo_detail_screen.dart';
import 'package:unsplash_app/presentation/widgets/photo_card.dart';

/// Pantalla "Favoritos": muestra los wallpapers guardados por el usuario.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    if (favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aún no tienes favoritos.\nToca el corazón en cualquier imagen para guardarla.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1200
            ? 5
            : width >= 900
                ? 4
                : width >= 600
                    ? 3
                    : 2;
        return MasonryGridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: columns,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final photo = favorites[index];
            return PhotoCard(
              photo: photo,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PhotoDetailScreen(photo: photo),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
