import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String key = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final List<String> taskList = tasks.map((task) {
        return jsonEncode(task.toMap());
      }).toList();

      await prefs.setStringList(key, taskList);
    } catch (e) {
      log('Error saving tasks: $e');
    }
  }

  // LOAD TASKS
  static Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final List<String>? storedTasks = prefs.getStringList(key);

      if (storedTasks == null) return [];

      return storedTasks.map((taskString) {
        final Map<String, dynamic> data = jsonDecode(taskString);
        return Task.fromMap(data);
      }).toList();
    } catch (e) {
      log('Error loading tasks: $e');
      return [];
    }
  }

  // CLEAR TASKS
  static Future<void> clearTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      log('Error clearing tasks: $e');
    }
  }
}
