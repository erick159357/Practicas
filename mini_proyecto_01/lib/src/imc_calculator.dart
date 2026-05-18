import 'package:flutter/material.dart';

class IMCCalculator extends StatefulWidget {
  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _estaturaController = TextEditingController();
  
  double _imc = 0.0;
  String _clasificacion = '';
  String _imagenPath = '';
  bool _mostrarResultado = false;

  void _calcularIMC() {
    final double peso = double.tryParse(_pesoController.text) ?? 0;
    final double estatura = double.tryParse(_estaturaController.text) ?? 0;
    
    if (peso > 0 && estatura > 0) {
      setState(() {
        _imc = peso / (estatura * estatura);
        _clasificacion = _obtenerClasificacion(_imc);
        _imagenPath = _obtenerImagen(_imc);
        _mostrarResultado = true;
      });
    } else {
      _mostrarError();
    }
  }

  String _obtenerClasificacion(double imc) {
    if (imc < 18) {
      return 'Bajo peso. Necesario evaluar tu estado de salud.';
    } else if (imc >= 18 && imc <= 24.9) {
      return 'Peso normal';
    } else if (imc >= 25 && imc <= 29.9) {
      return 'sobrepeso: controla tu alimentacion y evita el sedentarismo.';
    } else if (imc >= 30 && imc <= 34.9) {
      return 'Obesidad grado I: Riesgo relativo de enfermedades cardiovasculares.';
    } else if (imc >= 35 && imc <= 39.9) {
      return 'Obesidad grado II: Riesgo relativo muy alto de enfermedades cardiovasculares.';
    } else {
      return 'Obesidad grado III (mórbida): Riesgo extremadamente alto de enfermedades cardiovasculares.';
    }
  }

  String _obtenerImagen(double imc) {
    if (imc < 18) {
      return 'assets/images/bajo_peso.png';
    } else if (imc >= 18 && imc <= 24.9) {
      return 'assets/images/normal.png';
    } else if (imc >= 25 && imc <= 29.9) {
      return 'assets/images/sobrepeso.png';
    } else {
      return 'assets/images/obesidad.png';
    }
  }

  void _mostrarError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Por favor ingrese valores validos para peso y estatura.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _limpiarCampos() {
    setState(() {
      _pesoController.clear();
      _estaturaController.clear();
      _imc = 0.0;
      _clasificacion = '';
      _mostrarResultado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora IMC'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Ingrese sus datos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _pesoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Peso (Kilogramos)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.fitness_center),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _estaturaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Estatura (Metros)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.height),
                        hintText: 'Ej: 1.75',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _calcularIMC,
                          child: Text('Calcular IMC'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _limpiarCampos,
                          child: Text('Limpiar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_mostrarResultado)
              Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Resultado',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconForIMC(_imc),
                          size: 80,
                          color: _getColorForIMC(_imc),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_imagenPath.isNotEmpty)
                        Container(
                          height: 200,
                          width: 200,
                          child: Image.asset(
                            _imagenPath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Imagen no disponible',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 20),
                      Text(
                        'IMC: ${_imc.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _getColorForIMC(_imc),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: _getColorForIMC(_imc).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _clasificacion,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForIMC(double imc) {
    if (imc < 18) {
      return Icons.trending_down;
    } else if (imc >= 18 && imc <= 24.9) {
      return Icons.check_circle;
    } else if (imc >= 25 && imc <= 29.9) {
      return Icons.warning;
    } else {
      return Icons.error;
    }
  }

  Color _getColorForIMC(double imc) {
    if (imc < 18) {
      return Colors.orange;
    } else if (imc >= 18 && imc <= 24.9) {
      return Colors.green;
    } else if (imc >= 25 && imc <= 29.9) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _estaturaController.dispose();
    super.dispose();
  }
}