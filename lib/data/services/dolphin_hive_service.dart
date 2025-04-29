import 'package:dolphin_days/data/classes/dolphin_assignment.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DolphinHiveService {
  static const String _dolphinBoxName = 'dolphinAssignments';
  static Box<DolphinAssignment>? _box;

  static Future<void> init() async {
    
    _box = await Hive.openBox<DolphinAssignment>(_dolphinBoxName);
  }

  static Box<DolphinAssignment> get box {
    if (_box == null) {
      throw Exception('DolphinHiveService not initialized. Call init() first.');
    }
    return _box!;
  }

  static Future<void> putAssignment(String key, DolphinAssignment assignment) async {
    await box.put(key, assignment);
  }

  static DolphinAssignment? getAssignment(String key) {
    return box.get(key);
  }

  static List<DolphinAssignment> getAllAssignments() {
    return box.values.toList();
  }

  static Future<void> deleteAssignment(String key) async {
    await box.delete(key);
  }
}
