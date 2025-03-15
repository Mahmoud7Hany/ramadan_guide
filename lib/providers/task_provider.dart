import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  SharedPreferences? _prefs;
  static const String _tasksKey = 'tasks';

  List<Task> get tasks => _tasks..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  TaskProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTasks();
  }

  void _loadTasks() {
    try {
      final tasksJson = _prefs?.getStringList(_tasksKey) ?? [];
      _tasks = tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      _tasks = [];
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    try {
      final tasksJson = _tasks.map((task) => jsonEncode(task.toJson())).toList();
      await _prefs?.setStringList(_tasksKey, tasksJson);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  void deleteAllTasks() {
    _tasks.clear();
    _saveTasks();
    notifyListeners();
  }
}
