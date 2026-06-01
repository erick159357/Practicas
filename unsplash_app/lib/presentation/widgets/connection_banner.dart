import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unsplash_app/presentation/providers/providers.dart';

/// Banner que se muestra automáticamente cuando el dispositivo pierde la conexión a internet.
class ConnectionBanner extends ConsumerWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityStreamProvider);

    final isOffline = connectivity.maybeWhen(
      data: (results) => results.contains(ConnectivityResult.none),
      orElse: () => false,
    );

    // AnimatedSize para una transición suave al aparecer/desaparecer.
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: isOffline
          ? Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.errorContainer,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 18,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sin conexión · mostrando contenido guardado',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
