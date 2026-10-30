import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskController extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;

  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _dbService.getTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    if (title.trim().isEmpty) return;

    final newTask = Task(title: title.trim(), description: description.trim());

    await _dbService.insertTask(newTask);
    await loadTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = task.copyWith(completed: !task.completed);
    await _dbService.updateTask(updatedTask);
    await loadTasks();
  }

  Future<void> removeTask(int id) async {
    await _dbService.deleteTask(id);
    await loadTasks();
  }
}
