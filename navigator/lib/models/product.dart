import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final Color color;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
  });
}

/// Lista de productos de ejemplo.
final List<Product> mockProducts = [
  Product(
    id: 1,
    name: 'Laptop',
    description:
        'Laptop de alto rendimiento con procesador de ultima generacion, '
        '16 GB de RAM y 512 GB de almacenamiento SSD.',
    price: 15000.00,
    icon: Icons.laptop_mac,
    color: Colors.blue,
  ),
  Product(
    id: 2,
    name: 'Smartphone',
    description:
        'Teléfono inteligente con pantalla AMOLED de 6.5", cámara de 108 MP '
        'y batería de 5000 mAh. Perfecto para el uso diario.',
    price: 7000.00,
    icon: Icons.phone_android,
    color: Colors.green,
  ),
  Product(
    id: 3,
    name: 'Audífonos',
    description:
        'Audífonos inalámbricos con cancelación de ruido activa, '
        'hasta 30 horas de batería y sonido envolvente',
    price: 1200.00,
    icon: Icons.headphones,
    color: Colors.purple,
  ),
  Product(
    id: 4,
    name: 'Teclado Mecánico',
    description:
        'Teclado mecánico RGB, retroiluminación '
        'personalizable y diseño ergonómico para gaming y productividad.',
    price: 980.00,
    icon: Icons.keyboard,
    color: Colors.orange,
  ),
  Product(
    id: 5,
    name: 'Monitor',
    description:
        'Monitor 4K UHD de 27 pulgadas con tecnología IPS, 144 Hz de '
        'tasa de refresco. HDR10.',
    price: 9000.00,
    icon: Icons.monitor,
    color: Colors.teal,
  ),
  Product(
    id: 6,
    name: 'Mouse MMO',
    description:
        'Mouse alambrico con sensor de 25,000 DPI, '
        '14 botones programables, ideal para asignar multiples acciones o comandos.',
    price: 1400.00,
    icon: Icons.mouse,
    color: Colors.red,
  ),
  Product(
    id: 7,
    name: 'Tablet',
    description:
        'Tablet de 11 pulgadas con chip potente'
        'y teclado externo. Ideal para tomar apuntes y dibujar.',
    price: 9500.00,
    icon: Icons.tablet_mac,
    color: Colors.indigo,
  ),
  Product(
    id: 8,
    name: 'Smartwatch',
    description:
        'Reloj inteligente con GPS integrado, monitor cardíaco, '
        'resistente al agua y más de 100 modos deportivos.',
    price: 4500.00,
    icon: Icons.watch,
    color: Colors.brown,
  ),
];
