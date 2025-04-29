import 'package:hive_flutter/hive_flutter.dart';
import 'package:dolphin_days/data/classes/task_class.dart';

class HiveService {
  static const String _tasksBoxName = 'tasks';
  static Box<TaskClass>?
  _box;

  static Future<void> init() async {
    _box = await Hive.openBox<TaskClass>(_tasksBoxName);
  }

  static Box<TaskClass> get tasksBox {
    if (_box == null) {
      throw Exception('HiveService not initialized. Call init() first.');
    }
    return _box!;
  }

  static Future<void> addTask(TaskClass task) async {
    await tasksBox.put(task.id, task);
  }

  static List<TaskClass> getAllTasks() {
    return tasksBox.values.toList();
  }

  static Future<void> updateTask(TaskClass task) async {
    await tasksBox.put(task.id, task);
  }

  static Future<void> deleteTask(String taskId) async {
    await tasksBox.delete(taskId);
  }

}
