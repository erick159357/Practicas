import 'package:flutter/material.dart';

class IncrementPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _IncrementPageState();
  }
}
class _IncrementPageState extends State<IncrementPage>{
  int _conteo = 0;
  @override
  Widget build(BuildContext context){
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mi primer APP en Flutter'),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Text('Numero de Click', style : TextStyle(fontSize: 25)),
            Text('$_conteo', style: TextStyle(fontSize: 30, color: Colors.red))
          ],
        )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              setState(() {
                _conteo++;
              });
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10), 
          FloatingActionButton(
            onPressed: (){
              setState(() {
                _conteo--; //aqui decrementamos en lugar de incrementar.
              });
            },
            child: Icon(Icons.remove),
            backgroundColor: Colors.red, // le agregue un color  al segundo boton.
          ),
        ],
      )

      
    );
  }
}
