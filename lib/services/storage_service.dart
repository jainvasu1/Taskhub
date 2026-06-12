import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String key = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = tasks.map((t) => jsonEncode(t.toMap())).toList();
      await prefs.setStringList(key, data);
    } catch (_) {}
  }

  static Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList(key) ?? [];
      return data.map((e) => Task.fromMap(jsonDecode(e))).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
