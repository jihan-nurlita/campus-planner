import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Dibutuhkan untuk jsonEncode dan jsonDecode
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get incompleteTasks =>
      _tasks.where((t) => !t.isCompleted).toList();
  List<TaskModel> get completedTasks =>
      _tasks.where((t) => t.isCompleted).toList();

  TaskProvider() {
    loadTasks(); // Panggil saat provider pertama kali dibuat
  }

  // 1. Simpan data ke SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    // Ubah list TaskModel menjadi format JSON String
    final String encodedData = jsonEncode(
      _tasks.map((task) => task.toJson()).toList(),
    );
    await prefs.setString('saved_tasks', encodedData);
  }

  // 2. Muat data dari SharedPreferences saat aplikasi dibuka
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('saved_tasks');

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      _tasks = decodedData.map((item) => TaskModel.fromJson(item)).toList();
    } else {
      // Jika data kosong/pertama kali install, berikan data default
      _tasks = [
        TaskModel(
          id: '1',
          title: 'Desain UI/UX',
          subject: 'Pemrograman Mobile',
          deadline: DateTime.now().add(const Duration(days: 2)),
          description:
              'Buat prototype aplikasi mobile menggunakan Figma sesuai dengan user flow yang sudah ditentukan.',
          priority: 'Tinggi',
        ),
      ];
      _saveTasks();
    }
    notifyListeners();
  }

  void addTask(TaskModel task) {
    _tasks.add(task);
    _saveTasks(); // Simpan setiap kali ditambah
    notifyListeners();
  }

  void updateTask({
    required String id,
    required String title,
    required DateTime deadline,
    String? subject,
    String? description,
    String? priority,
  }) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = TaskModel(
        id: id,
        title: title,
        subject: subject ?? _tasks[index].subject,
        deadline: deadline,
        description: description ?? _tasks[index].description,
        priority: priority ?? _tasks[index].priority,
        isCompleted: _tasks[index].isCompleted,
      );
      _saveTasks(); // Simpan setiap kali di-update
      notifyListeners();
    }
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _saveTasks(); // Simpan setiap kali status berubah
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks(); // Simpan setiap kali dihapus
    notifyListeners();
  }
}
