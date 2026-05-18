import 'package:flutter/material.dart';
import 'models/product.dart';
import 'pages/home_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Productos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      // Ruta inicial
      initialRoute: '/',

      // ========= onGenerateRoute =========
      // Maneja todas las rutas de la aplicación, incluyendo rutas dinámicas como /product/1, /product/2, etc.
      onGenerateRoute: (RouteSettings settings) {
        final uri = Uri.parse(settings.name ?? '');

        // Pantalla principal 
        if (uri.path == '/') {
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
            settings: settings,
          );
        }

        // Ruta: /cart  Pantalla del carrito
        if (uri.path == '/cart') {
          return MaterialPageRoute(
            builder: (_) => const CartPage(),
            settings: settings,
          );
        }

        // Ruta dinámica: /product/:id   Detalle del producto
        // Ejemplo: /product/3 abre el producto con id 3.
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'product') {
          final productId = int.tryParse(uri.pathSegments[1]);

          if (productId != null) {
            // Busca el producto por ID en la lista mock.
            final product = mockProducts.firstWhere(
              (p) => p.id == productId,
              orElse: () => mockProducts.first,
            );

            return MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product),
              settings: settings,
            );
          }
        }

        // Ruta no encontrada → Pantalla de error 404
        return MaterialPageRoute(
          builder: (_) => const _NotFoundPage(),
          settings: settings,
        );
      },
    );
  }
}

/// Pantalla que se muestra cuando la ruta no existe.
class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'Página no encontrada',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
