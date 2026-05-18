import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RecordsScreen extends StatefulWidget {
  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  int selectedLevel = 8;
  List<Map<String, dynamic>> records = [];
  
  @override
  void initState() {
    super.initState();
    _loadRecords();
  }
  
  void _loadRecords() async {      //aqui se obtiene los datos guardados de la partida completada de acuerdo el nivel seleccionado.
    List<Map<String, dynamic>> data = await dbHelper.getRecords(selectedLevel);
    setState(() {
      records = data;
    });
  }
  
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  
  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }
  
  Color _getMedalColor(int position) {
    switch (position) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey.shade400;
      case 2:
        return Colors.brown.shade300;
      default:
        return Colors.transparent;
    }
  }
  
  IconData _getMedalIcon(int position) {
    switch (position) {
      case 0:
        return Icons.looks_one;
      case 1:
        return Icons.looks_two;
      case 2:
        return Icons.looks_3;
      default:
        return Icons.emoji_events;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text('Récords 🏆'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Borrar todos los récords'),
                  content: Text('¿Estás seguro? Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await dbHelper.clearAllRecords();
                        Navigator.pop(context);
                        _loadRecords();
                      },
                      child: Text('Borrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            color: Colors.cyan,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLevelTab('Fácil', 8, Colors.green),
                _buildLevelTab('Medio', 10, Colors.orange),
                _buildLevelTab('Difícil', 12, Colors.red),
              ],
            ),
          ),
          Expanded(
            child: records.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No hay récords aún',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '¡Juega para establecer nuevos récords!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        elevation: index < 3 ? 5 : 2,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _getMedalColor(index),
                              width: index < 3 ? 2 : 0,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getMedalColor(index),
                              child: index < 3
                                  ? Icon(
                                      _getMedalIcon(index),
                                      color: Colors.white,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            title: Text(
                              'Tiempo: ${_formatTime(record['time'])}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              'Movimientos: ${record['movements']} • Fecha: ${_formatDate(record['date'])}',
                            ),
                            trailing: index == 0
                                ? Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 30,
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLevelTab(String label, int level, Color color) {
    bool isSelected = selectedLevel == level;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLevel = level;
        });
        _loadRecords();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}