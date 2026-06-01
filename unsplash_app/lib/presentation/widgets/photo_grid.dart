import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_app/core/errors/failures.dart';
import 'package:unsplash_app/domain/entities/photo.dart';
import 'package:unsplash_app/presentation/providers/photo_list_state.dart';
import 'package:unsplash_app/presentation/screens/photo_detail_screen.dart';
import 'package:unsplash_app/presentation/widgets/photo_card.dart';

/// Cuadrícula responsiva tipo mosaico (masonry), con paginación infinita.
/// Recibe el estado de la lista y dos callbacks: cargar más y reintentar.
class PhotoGrid extends StatefulWidget {
  final PhotoListState state;
  final Future<void> Function() onLoadMore;
  final Future<void> Function() onRefresh;

  const PhotoGrid({
    super.key,
    required this.state,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Cuando faltan 400px para el final, pedimos la siguiente pagina.
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      widget.onLoadMore();
    }
  }

  /// Calcula el numero de columnas según el ancho disponible (responsivo).
  int _columnsFor(double width) {
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    // 1) Cargando la primera página.
    if (state.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) Error sin datos previos.
    if (state.isEmpty && state.failure != null) {
      return _ErrorView(
        failure: state.failure!,
        onRetry: widget.onRefresh,
      );
    }

    // 3) Sin resultados.
    if (state.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No hay imágenes para mostrar.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // 4) Cuadrícula con datos.
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _columnsFor(constraints.maxWidth);
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: columns,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childCount: state.photos.length,
                  itemBuilder: (context, index) {
                    final photo = state.photos[index];
                    return PhotoCard(
                      photo: photo,
                      onTap: () => _openDetail(context, photo),
                    );
                  },
                ),
              ),
              // Indicador de "cargando más" al final.
              if (state.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              // Mensaje cuando ya no hay más resultados.
              if (state.hasReachedEnd && !state.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('No hay más resultados'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, Photo photo) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PhotoDetailScreen(photo: photo)),
    );
  }
}

/// Vista de error reutilizable con botón de reintentar.
class _ErrorView extends StatelessWidget {
  final Failure failure;
  final Future<void> Function() onRetry;

  const _ErrorView({required this.failure, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    if (failure is NetworkFailure) {
      icon = Icons.wifi_off;
    } else if (failure is RateLimitFailure) {
      icon = Icons.hourglass_top;
    } else {
      icon = Icons.error_outline;
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              failure.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
