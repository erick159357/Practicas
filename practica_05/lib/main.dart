import 'package:flutter/material.dart';
import 'package:practica_05/src/slider_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: SliderPage(),
    ); 
  }
}