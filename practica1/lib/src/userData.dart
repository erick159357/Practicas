import 'package:flutter/material.dart';
import 'package:practica1/src/myAlertDialog.dart';

class DatosUsuarios extends StatefulWidget {
  @override
  _DatosUsuarios createState() => _DatosUsuarios();
}

class _DatosUsuarios extends State<DatosUsuarios> {
  var _name;
  var _phone;
  
  final nameCtrl = new TextEditingController();
  final phoneCtrl = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practica 01'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ), // AppBar
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/uaspng.png'),
          SizedBox(height: 10.0),
          TextField(
            controller: nameCtrl,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              hintText: 'Ingresa un nombre',
            ), // InputDecoration
          ), // TextField
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              hintText: 'Ingresa número de celular',
            ), // InputDecoration
          ), // TextField
          SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.amber), // Color Texto,
            child: Text('Enviar'),
            onPressed: () {
              _name = nameCtrl.text;
              _phone = phoneCtrl.text;
              
              setState(() {
                showAlertDialog(
                  context,
                  "El usuario $_name, tiene un teléfono $_phone",
                  'Mi APP :)',
                  'OK',
                  ':(');
              });
            }, // onPressed
          ), // ElevatedButton
        ], // <Widget>[]
      ), // Column
    ); // Scaffold
  }
}
