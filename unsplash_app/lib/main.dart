import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unsplash_app/core/theme/app_theme.dart';
import 'package:unsplash_app/presentation/providers/providers.dart';
import 'package:unsplash_app/presentation/providers/theme_provider.dart';
import 'package:unsplash_app/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unsplash Wallpapers',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode, 
      home: const MainScreen(),
    );
  }
}
