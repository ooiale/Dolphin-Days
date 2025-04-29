import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:dolphin_days/data/enums/hive_type_ids.dart';

part 'task_class.g.dart'; // This will be generated

@HiveType(typeId: HiveTypeIds.taskClass)
class TaskClass {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final TimeOfDay? startTime;

  @HiveField(4)
  final TimeOfDay? endTime;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  final Priority priority;

  @HiveField(7)
  final String category;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final DateTime? reminder;

  TaskClass({
    String? id,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isCompleted = false,
    this.priority = Priority.medium,
    required this.category,
    this.notes,
    this.reminder,
  }) : id = id ?? Uuid().v4(); // Generate a unique ID if not provided

  // useful for updating values
  TaskClass copyWith({
    String? id,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? isCompleted,
    Priority? priority,
    String? category,
    String? notes,
  }) {
    return TaskClass(
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }
}

// Register Priority enum with Hive
@HiveType(typeId: HiveTypeIds.priority)
enum Priority {
  @HiveField(0)
  high,

  @HiveField(1)
  medium,

  @HiveField(2)
  low,
}

// Adapter for TimeOfDay since it's not natively supported by Hive
class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = HiveTypeIds.timeOfDayAdapter; // Unique typeId

  @override
  TimeOfDay read(BinaryReader reader) {
    final hour = reader.readByte();
    final minute = reader.readByte();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeByte(obj.hour);
    writer.writeByte(obj.minute);
  }
}
