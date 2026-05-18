import 'package:flutter/material.dart';
import 'package:practica1/src/app.dart';
import 'package:practica1/src/userData.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica 1',
      home: DatosUsuarios()
    );
  }
}