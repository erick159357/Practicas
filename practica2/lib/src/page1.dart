import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Practica 02'),
        centerTitle: true,
      ), // AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Pagina 2'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.amber,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/Page2');
              }, // onPressed
            ), // ElevatedButton
            ElevatedButton(
              child: Text('Pagina 3'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/Page3');
              }, // onPressed
            ), // ElevatedButton
          ], // <Widget>[]
        ), // Column
      ), // Center
    ); // Scaffold
  }
}