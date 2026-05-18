import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

// ========= StateNotifier =========
// Maneja el estado de la lista de tareas. Cada método crea una nueva lista (estado inmutable) y la asigna a [state].
class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  /// Agrega una nueva tarea a la lista.
  void addTask(String title) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    state = [...state, newTask];
  }

  /// Alterna el estado completado/pendiente de una tarea.
  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isCompleted: !task.isCompleted) else task,
    ];
  }

  /// Elimina una tarea de la lista por su ID.
  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }
}

// ========= StateNotifierProvider =========
// Expone el TaskNotifier y su estado (List<Task>) a toda la app.
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});
