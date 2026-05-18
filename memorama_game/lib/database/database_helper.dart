import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  
  factory DatabaseHelper() => _instance;
  
  DatabaseHelper._internal();
  
  static const String _recordsKey = 'memorama_records';
  
  // Modelo de Record
  
  Future<List<Map<String, dynamic>>> _getAllStoredRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recordsJson = prefs.getString(_recordsKey);
    
    if (recordsJson == null || recordsJson.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = json.decode(recordsJson);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      print('Error decoding records: $e');
      return [];
    }
  }
  
  Future<void> _saveAllRecords(List<Map<String, dynamic>> records) async {
    final prefs = await SharedPreferences.getInstance();
    final String recordsJson = json.encode(records);
    await prefs.setString(_recordsKey, recordsJson);
  }
  
  Future<int> insertRecord(Map<String, dynamic> record) async {
    List<Map<String, dynamic>> records = await _getAllStoredRecords();
    
    // Crear el record con ID único
    final newRecord = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'level': record['level'],
      'time': record['time'],
      'movements': record['movements'],
      'date': record['date'],
    };
    
    records.add(newRecord);
    await _saveAllRecords(records);
    
    return newRecord['id'] as int;
  }
  
  Future<List<Map<String, dynamic>>> getRecords(int level) async {
    List<Map<String, dynamic>> allRecords = await _getAllStoredRecords();
    
    // Filtrar por nivel
    List<Map<String, dynamic>> filteredRecords = allRecords
        .where((record) => record['level'] == level)
        .toList();
    
    // Ordenar por tiempo (ascendente)
    filteredRecords.sort((a, b) => (a['time'] as int).compareTo(b['time'] as int));
    
    // Limitar a 10 registros
    if (filteredRecords.length > 10) {
      filteredRecords = filteredRecords.sublist(0, 10);
    }
    
    return filteredRecords;
  }
  
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    List<Map<String, dynamic>> allRecords = await _getAllStoredRecords();
    
    // Ordenar por tiempo (ascendente)
    allRecords.sort((a, b) => (a['time'] as int).compareTo(b['time'] as int));
    
    return allRecords;
  }
  
  Future<Map<String, dynamic>?> getBestRecord(int level) async {
    List<Map<String, dynamic>> records = await getRecords(level);
    
    if (records.isNotEmpty) {
      return records.first;
    }
    return null;
  }
  
  Future<int> deleteRecord(int id) async {
    List<Map<String, dynamic>> records = await _getAllStoredRecords();
    
    // Filtrar para eliminar el record con el ID especificado
    final originalLength = records.length;
    records.removeWhere((record) => record['id'] == id);
    
    await _saveAllRecords(records);
    
    // Retornar 1 si se eliminó algo, 0 si no
    return originalLength > records.length ? 1 : 0;
  }
  
  Future<void> clearAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recordsKey);
  }
}