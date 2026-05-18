import 'package:flutter/material.dart';

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double valor = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slider Page'),
        centerTitle: true,
        backgroundColor: Colors.green[300],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            width: 400,
            color: Colors.black54,
            child: Slider(
              value: valor,
              min: 0,
              max: 400,
              label: valor.round().toString(),
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  valor = value;
                });
              },
            ), 
          ), 

          Container(
            width: 400,
            height: 580,
            color: Colors.black54,
            child: Center(
              child: Image(
                image: AssetImage('assets/gatochad.png'),
                height: valor,
                width: valor,
              ), 
            ), 
          ), 
        ],
      ), 
    ); 
  }
}
