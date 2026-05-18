import 'package:flutter/material.dart';
import 'package:practica_06/src/tabs_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Practica 06',
      home: TabsPage(),
    ); 
  }
}
