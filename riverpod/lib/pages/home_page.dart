import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

// ========= ConsumerWidget =========
// Extiende de ConsumerWidget en lugar de StatelessWidget para poder acceder al estado de Riverpod mediante [ref].
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch escucha los cambios del provider y reconstruye el widget.
    final tasks = ref.watch(taskProvider);

    // Separar tareas pendientes y completadas.
    final pending = tasks.where((t) => !t.isCompleted).toList();
    final completed = tasks.where((t) => t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
        centerTitle: true,
        actions: [
          // Muestra el contador de tareas pendientes.
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${pending.length} pendientes',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay tareas aún',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Presiona + para agregar una',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // --- Sección de pendientes ---
                if (pending.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Pendientes',
                    count: pending.length,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  ...pending.map((task) => _TaskCard(task: task)),
                  const SizedBox(height: 16),
                ],

                // --- Sección de completadas ---
                if (completed.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Completadas',
                    count: completed.length,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  ...completed.map((task) => _TaskCard(task: task)),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Muestra un diálogo para agregar una nueva tarea.
  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Nueva Tarea'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Escribe el nombre de la tarea',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              _addTask(ctx, ref, controller);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                _addTask(ctx, ref, controller);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  /// Agrega la tarea y cierra el diálogo.
  void _addTask(
      BuildContext context, WidgetRef ref, TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      // ref.read accede al notifier para llamar métodos sin escuchar cambios.
      ref.read(taskProvider.notifier).addTask(text);
      Navigator.pop(context);
    }
  }
}

/// Encabezado de sección (Pendientes / Completadas).
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$title ($count)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ========= ConsumerWidget =========
// Cada tarjeta también es un ConsumerWidget para acceder al ref.
class _TaskCard extends ConsumerWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // Checkbox para marcar como completada.
        leading: Checkbox(
          value: task.isCompleted,
          activeColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onChanged: (_) {
            // Alterna el estado de la tarea.
            ref.read(taskProvider.notifier).toggleTask(task.id);
          },
        ),
        // Título de la tarea (tachado si está completada).
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 15,
            decoration:
                task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        // Botón para eliminar la tarea.
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            ref.read(taskProvider.notifier).removeTask(task.id);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tarea "${task.title}" eliminada'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
