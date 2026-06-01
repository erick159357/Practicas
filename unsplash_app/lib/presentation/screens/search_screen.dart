import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unsplash_app/presentation/providers/search_provider.dart';
import 'package:unsplash_app/presentation/widgets/photo_grid.dart';

/// Pantalla "Buscar": campo de texto para buscar por palabra clave y cuadrícula de resultados con paginación infinita.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      FocusScope.of(context).unfocus();
      ref.read(searchProvider.notifier).search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);
    final hasSearched = notifier.query.isNotEmpty;

    return Column(
      children: [
        // Campo de búsqueda.
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'Busca wallpapers (naturaleza, autos, espacio...)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        notifier.clear();
                        setState(() {});
                      },
                    ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        // Contenido.
        Expanded(
          child: !hasSearched
              ? const _SearchPrompt()
              : PhotoGrid(
                  state: state,
                  onLoadMore: notifier.loadNextPage,
                  onRefresh: () => notifier.search(notifier.query),
                ),
        ),
      ],
    );
  }
}

/// Mensaje que se muestra antes de que el usuario haga su primera busqueda.
class _SearchPrompt extends StatelessWidget {
  const _SearchPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_search,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Escribe una palabra clave para buscar wallpapers',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
