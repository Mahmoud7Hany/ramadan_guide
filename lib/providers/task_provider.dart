import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  // تحميل المهام من shared_preferences عند بدء التطبيق
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    String? tasksData = prefs.getString('tasks');
    if (tasksData != null) {
      List<dynamic> jsonList = jsonDecode(tasksData);
      _tasks = jsonList.map((jsonTask) => Task.fromJson(jsonTask)).toList();
      notifyListeners();
    }
  }

  // حفظ المهام في shared_preferences
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList =
        _tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', jsonEncode(jsonList));
  }

  // إضافة مهمة جديدة وحفظ التغييرات
  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  // تبديل حالة يوم من أيام المهمة وحفظ التغييرات
  void toggleTaskDay(String taskId, int day) {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.completedDays[day] = !(task.completedDays[day] ?? false);
    saveTasks();
    notifyListeners();
  }

  // حذف مهمة محددة
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    saveTasks();
    notifyListeners();
  }

// حذف جميع المهام
  void deleteAllTasks() {
    _tasks.clear();
    saveTasks();
    notifyListeners();
  }
}
