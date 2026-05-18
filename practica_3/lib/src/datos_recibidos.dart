import 'package:flutter/material.dart';
import 'package:practica_3/src/home_page.dart';

class DatosPage extends StatelessWidget {
  final Data? data;
  
  DatosPage({this.data});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 158, 202),
        title: Text('Datos Recibidos'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Los datos son:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nombre: ${data?.nombre ?? 'Sin nombre'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Sexo: ${data?.sexo ?? 'Sin especificar'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepOrange[200],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}