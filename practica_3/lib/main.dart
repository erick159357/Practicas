import 'package:flutter/material.dart';
import 'package:practica_3/src/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica 3',
      home: HomePage()
    );
  }
}