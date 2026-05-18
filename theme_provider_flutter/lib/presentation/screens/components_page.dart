import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_theme/data/theme/theme_notifier.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage>
    with SingleTickerProviderStateMixin {
  // Estado local para componentes interactivos.
  bool _switchValue = true;
  bool _checkValue = true;
  int _radioValue = 0;
  double _sliderValue = 0.6;
  double _progress = 0.45;
  final TextEditingController _textCtrl = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final themeNotifier = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de componentes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.text_fields), text: 'Textos'),
            Tab(icon: Icon(Icons.touch_app), text: 'Interacción'),
            Tab(icon: Icon(Icons.dashboard), text: 'Contenedores'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tema activo: ${themeNotifier.currentType.label}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: const Icon(Icons.info_outline),
        label: const Text('Mostrar aviso'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTypographyTab(theme, scheme),
          _buildInteractionTab(theme, scheme),
          _buildContainersTab(theme, scheme),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────
  // TIPOGRAFÍA Y COLORES
  // ───────────────────────────────────────────────────────────────────
  Widget _buildTypographyTab(ThemeData theme, ColorScheme scheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionTitle('Jerarquía tipográfica'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Título principal', style: theme.textTheme.displayLarge),
                const SizedBox(height: 8),
                Text('Encabezado', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Título grande', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Título mediano', style: theme.textTheme.titleMedium),
                const Divider(height: 24),
                Text(
                  'Texto grande: Lorem ipsum dolor sit amet, consectetur '
                  'adipiscing elit. Este párrafo usa el estilo de texto '
                  'principal del tema.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Texto regular: Sed do eiusmod tempor incididunt ut labore '
                  'et dolore magna aliqua. Este párrafo usa el estilo '
                  'secundario.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Etiqueta · DESTACADO',
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('Paleta del tema'),
        _ColorPalette(scheme: scheme),
        const SizedBox(height: 20),
        _SectionTitle('Íconos'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 24,
              runSpacing: 16,
              alignment: WrapAlignment.spaceAround,
              children: [
                _IconBox(icon: Icons.favorite, label: 'Principal', color: scheme.primary),
                _IconBox(icon: Icons.star, label: 'Secundario', color: scheme.secondary),
                _IconBox(icon: Icons.bolt, label: 'Terciario', color: scheme.tertiary),
                _IconBox(icon: Icons.warning, label: 'Error', color: scheme.error),
                _IconBox(icon: Icons.check_circle, label: 'Texto', color: scheme.onSurface),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────
  // COMPONENTES INTERACTIVOS
  // ───────────────────────────────────────────────────────────────────
  Widget _buildInteractionTab(ThemeData theme, ColorScheme scheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionTitle('Botones'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Elevado')),
                FilledButton(onPressed: () {}, child: const Text('Relleno')),
                FilledButton.tonal(onPressed: () {}, child: const Text('Suave')),
                OutlinedButton(onPressed: () {}, child: const Text('Con borde')),
                TextButton(onPressed: () {}, child: const Text('De texto')),
                IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('Campos de texto'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _textCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Escribe tu nombre',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'tu@correo.com',
                    prefixIcon: const Icon(Icons.email),
                    suffixIcon: const Icon(Icons.check_circle_outline),
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('Controles de selección'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notificaciones activas'),
                  subtitle: const Text('Recibe alertas en tu dispositivo'),
                  value: _switchValue,
                  onChanged: (v) => setState(() => _switchValue = v),
                  secondary: const Icon(Icons.notifications),
                ),
                const Divider(),
                CheckboxListTile(
                  title: const Text('Aceptar términos y condiciones'),
                  value: _checkValue,
                  onChanged: (v) => setState(() => _checkValue = v ?? false),
                  secondary: const Icon(Icons.rule),
                ),
                const Divider(),
                RadioListTile<int>(
                  title: const Text('Plan mensual'),
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: (v) => setState(() => _radioValue = v!),
                ),
                RadioListTile<int>(
                  title: const Text('Plan anual'),
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (v) => setState(() => _radioValue = v!),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('Deslizador y progreso'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Volumen: ${(_sliderValue * 100).toInt()}%',
                    style: theme.textTheme.titleMedium),
                Slider(
                  value: _sliderValue,
                  onChanged: (v) => setState(() {
                    _sliderValue = v;
                    _progress = v;
                  }),
                ),
                const SizedBox(height: 8),
                Text('Barra de progreso', style: theme.textTheme.labelLarge),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Indicador circular usando el color principal del tema.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('Diálogos y menús'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.message),
                  label: const Text('Mostrar diálogo'),
                  onPressed: _showDemoDialog,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.menu),
                  label: const Text('Panel inferior'),
                  onPressed: _showBottomSheet,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 80), // espacio para el FAB
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────
  //CONTENEDORES Y LISTAS
  // ───────────────────────────────────────────────────────────────────
  Widget _buildContainersTab(ThemeData theme, ColorScheme scheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionTitle('Tarjetas'),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              child: const Icon(Icons.person),
            ),
            title: const Text('Ana García'),
            subtitle: const Text('Toca para ver el perfil'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: scheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info, color: scheme.onPrimaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tienes una nueva notificación pendiente',
                    style: TextStyle(color: scheme.onPrimaryContainer),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: scheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: scheme.onErrorContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Atención: revisa este detalle antes de continuar',
                    style: TextStyle(color: scheme.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('Etiquetas'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                const Chip(label: Text('Etiqueta básica')),
                Chip(
                  avatar: const Icon(Icons.star, size: 18),
                  label: const Text('Con ícono'),
                  backgroundColor: scheme.secondaryContainer,
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Acción'),
                  onPressed: () {},
                ),
                FilterChip(
                  label: const Text('Filtro'),
                  selected: _switchValue,
                  onSelected: (v) => setState(() => _switchValue = v),
                ),
                InputChip(
                  label: const Text('Entrada'),
                  onDeleted: () {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('Lista de elementos'),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: List.generate(4, (index) {
              final titles = [
                'Mensajes',
                'Fotos',
                'Configuración',
                'Ayuda',
              ];
              final icons = [
                Icons.mail,
                Icons.photo_library,
                Icons.settings,
                Icons.help,
              ];
              return Column(
                children: [
                  ListTile(
                    leading: Icon(icons[index]),
                    title: Text(titles[index]),
                    subtitle: Text('Ver ${titles[index].toLowerCase()}'),
                    trailing: Badge(
                      label: Text('${index + 2}'),
                      child: const Icon(Icons.notifications_none),
                    ),
                    onTap: () {},
                  ),
                  if (index < 3) const Divider(height: 1),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('Divisores y bordes'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: scheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Contenedor con borde'),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Contenedor con fondo resaltado',
                    style: TextStyle(color: scheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────
  // DIÁLOGOS / PANELES
  // ───────────────────────────────────────────────────────────────────

  void _showDemoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.lightbulb_outline),
        title: const Text('Diálogo de ejemplo'),
        content: const Text(
          'Este diálogo también hereda los colores, la forma y la '
          'tipografía del tema activo en la aplicación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Panel inferior',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Los paneles inferiores también se adaptan al tema: '
                'fondo, tipografía, indicador y botones.',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────
// WIDGETS AUXILIARES
// ───────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ColorPalette extends StatelessWidget {
  final ColorScheme scheme;
  const _ColorPalette({required this.scheme});

  @override
  Widget build(BuildContext context) {
    final swatches = [
      ('Principal', scheme.primary, scheme.onPrimary),
      ('Secundario', scheme.secondary, scheme.onSecondary),
      ('Terciario', scheme.tertiary, scheme.onTertiary),
      ('Error', scheme.error, scheme.onError),
      ('Superficie', scheme.surface, scheme.onSurface),
      ('Resaltado', scheme.primaryContainer, scheme.onPrimaryContainer),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: swatches.map((s) {
            return Container(
              width: 100,
              height: 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: s.$2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s.$1,
                    style: TextStyle(
                      color: s.$3,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '#${s.$2.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                    style: TextStyle(color: s.$3, fontSize: 11),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _IconBox({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
