import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'records_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text('Juego de Memoria 🧠'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.psychology,
                size: 100,
                color: Colors.cyan,
              ),
              SizedBox(height: 40),
              Text(
                'Selecciona el Nivel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 30),
              _buildLevelButton(
                context,
                'Fácil (8 pares)',
                Colors.green,
                8,
                Icons.sentiment_satisfied,
              ),
              SizedBox(height: 15),
              _buildLevelButton(
                context,
                'Medio (10 pares)',
                Colors.orange,
                10,
                Icons.sentiment_neutral,
              ),
              SizedBox(height: 15),
              _buildLevelButton(
                context,
                'Difícil (12 pares)',
                Colors.red,
                12,
                Icons.sentiment_very_dissatisfied,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecordsScreen()),
                  );
                },
                icon: Icon(Icons.emoji_events),
                label: Text('Ver Récords'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(
    BuildContext context,
    String label,
    Color color,
    int pairs,
    IconData icon,
  ) {
    return Container(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(pairs: pairs),
            ),
          );
        },
        icon: Icon(icon, size: 28),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          textStyle: TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}