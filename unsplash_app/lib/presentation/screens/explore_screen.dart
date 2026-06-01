import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unsplash_app/presentation/providers/explore_provider.dart';
import 'package:unsplash_app/presentation/widgets/photo_grid.dart';

/// Pantalla "Explorar": muestra las fotos más recientes de Unsplash en una cuadrícula tipo mosaico con paginación infinita.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreProvider);
    final notifier = ref.read(exploreProvider.notifier);

    return PhotoGrid(
      state: state,
      onLoadMore: notifier.loadNextPage,
      onRefresh: notifier.loadFirstPage,
    );
  }
}
