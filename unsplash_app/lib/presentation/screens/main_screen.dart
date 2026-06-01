import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unsplash_app/core/constants/api_constants.dart';
import 'package:unsplash_app/presentation/providers/theme_provider.dart';
import 'package:unsplash_app/presentation/screens/explore_screen.dart';
import 'package:unsplash_app/presentation/screens/favorites_screen.dart';
import 'package:unsplash_app/presentation/screens/search_screen.dart';
import 'package:unsplash_app/presentation/widgets/connection_banner.dart';

/// Pantalla contenedora con la barra de navegación inferior.
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  static const _titles = ['Explorar', 'Buscar', 'Favoritos'];

  // IndexedStack mantiene vivo el estado de cada pestaña al cambiar entre ellas.
  final _screens = const [
    ExploreScreen(),
    SearchScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            tooltip: 'Cambiar tema',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: Column(
        children: [
          const ConnectionBanner(),
          // Aviso si la Access Key no está configurada.
          if (!ApiConstants.isKeyConfigured) const _ApiKeyWarning(),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}

/// Banner de advertencia cuando falta configurar la Access Key.
class _ApiKeyWarning extends StatelessWidget {
  const _ApiKeyWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.amber.shade700,
      padding: const EdgeInsets.all(10),
      child: const Text(
        '⚠️ Falta configurar tu Access Key de Unsplash en api_constants.dart',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }
}
