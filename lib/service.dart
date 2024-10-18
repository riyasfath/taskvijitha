import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'model.dart';

class TaskService {
  static Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasks');
    if (taskStrings == null) return [];
    return taskStrings.map((taskString) => Task.fromJson(json.decode(taskString))).toList();
  }

  static Future<void> addTask(Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasks') ?? [];
    taskStrings.add(json.encode(task.toJson()));
    await prefs.setStringList('tasks', taskStrings);
  }

  static Future<void> editTask(Task oldTask, String newTitle, DateTime newDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasks') ?? [];

    int index = taskStrings.indexWhere((taskString) => taskString.contains(oldTask.title));
    if (index != -1) {
      taskStrings[index] = json.encode(Task(title: newTitle, date: newDate).toJson());
      await prefs.setStringList('tasks', taskStrings);
    }
  }

  static Future<void> deleteTask(Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasks') ?? [];
    taskStrings.removeWhere((taskString) => taskString.contains(task.title));
    await prefs.setStringList('tasks', taskStrings);
  }
}
