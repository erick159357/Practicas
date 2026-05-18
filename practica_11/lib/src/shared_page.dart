import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPage extends StatefulWidget {
  @override
  _SharedPageState createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  int _edad = 0;
  String _nombre = '';

  @override
  void initState() {
    super.initState();
    _grabarDatos(); 
  }

  
  Future<void> _grabarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', 'Erick Garcia');
    await prefs.setInt('edad', 24);
  }

  
  Future<void> _leerDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombre = prefs.getString('nombre') ?? ' ';
      _edad = prefs.getInt('edad') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practica 11'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nombre: $_nombre',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Edad: $_edad', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.refresh),
        onPressed: _leerDatos, 
      ),
    );
  }
}
