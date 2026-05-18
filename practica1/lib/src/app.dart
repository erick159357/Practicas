import 'package:flutter/material.dart';
import 'package:practica1/src/userData.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica 01',
      home: Center(
        child: DatosUsuarios(),
      ));
  }
}