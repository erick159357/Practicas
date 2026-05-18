import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_theme/data/theme/theme_notifier.dart';

import 'components_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temas y apariencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.widgets_outlined),
            tooltip: 'Ver galería de componentes',
            onPressed: () => _openComponentsPage(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CurrentThemeCard(currentType: themeNotifier.currentType),
          const SizedBox(height: 20),
          Text(
            'Selecciona un tema',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'La selección se guarda automáticamente y se restaura al reabrir la app.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final type in AppThemeType.values) ...[
                  RadioListTile<AppThemeType>(
                    value: type,
                    groupValue: themeNotifier.currentType,
                    onChanged: (value) {
                      if (value != null) themeNotifier.setTheme(value);
                    },
                    title: Text(type.label),
                    subtitle: Text(type.description),
                    secondary: Icon(type.icon),
                  ),
                  if (type != AppThemeType.values.last)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _openComponentsPage(context),
            icon: const Icon(Icons.dashboard_customize),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Ver galería de componentes'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Los componentes de esa pantalla cambian con cada tema',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _openComponentsPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ComponentsPage()),
    );
  }
}

/// Tarjeta que muestra el tema actualmente activo.
class _CurrentThemeCard extends StatelessWidget {
  final AppThemeType currentType;
  const _CurrentThemeCard({required this.currentType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final resolvedInfo = currentType == AppThemeType.system
        ? ' · El sistema está en ${platformBrightness == Brightness.dark ? 'oscuro' : 'claro'}'
        : '';

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              child: Icon(currentType.icon, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tema actual',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentType.label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${currentType.description}$resolvedInfo',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
