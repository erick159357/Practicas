// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_theme/data/theme/theme_notifier.dart';

import 'presentation/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Creamos el notifier y cargamos la preferencia guardada ANTES de arrancar la app
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeNotifier,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Provider Theme',
          theme: themeNotifier.lightTheme,
          darkTheme: themeNotifier.darkTheme,
          themeMode: themeNotifier.themeMode,

          home: const HomePage(),
        );
      },
    );
  }
}
