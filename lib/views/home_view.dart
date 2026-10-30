import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/task_controller.dart';
import '../controllers/settings_controller.dart';
import 'settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _showAddTaskSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final lang = context.read<SettingsController>().language;

    final isEn = lang == 'en';
    final isFr = lang == 'fr';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: isEn ? 'Title' : (isFr ? 'Titre' : 'Título'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: isEn
                    ? 'Description'
                    : (isFr ? 'Description' : 'Descripción'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (titleController.text.trim().isNotEmpty) {
                    await context.read<TaskController>().addTask(
                      titleController.text,
                      descController.text,
                    );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: Text(
                  isEn ? 'Add Task' : (isFr ? 'Ajouter' : 'Añadir Tarea'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();
    final lang = context.watch<SettingsController>().language;

    final isEn = lang == 'en';
    final isFr = lang == 'fr';

    final title = isEn ? 'My Tasks' : (isFr ? 'Mes tâches' : 'Mis Tareas');
    final emptyMsg = isEn
        ? 'No tasks yet'
        : (isFr ? 'Aucune tâche' : 'No hay tareas registradas');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsView()),
              );
            },
          ),
        ],
      ),
      body: taskController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskController.tasks.isEmpty
          ? Center(child: Text(emptyMsg))
          : ListView.separated(
              itemCount: taskController.tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final task = taskController.tasks[index];
                return ListTile(
                  leading: IconButton(
                    icon: Icon(
                      task.completed
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.completed ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => taskController.toggleTaskStatus(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: task.description.isNotEmpty
                      ? Text(task.description)
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      if (task.id != null) {
                        taskController.removeTask(task.id!);
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
