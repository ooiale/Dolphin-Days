import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:flutter/material.dart';

// Helper function to compare two TimeOfDay objects
int compareTimes(TimeOfDay a, TimeOfDay b) {
  if (a.hour != b.hour) return a.hour - b.hour;
  return a.minute - b.minute;
}

String timeIntervalText(TaskClass task, BuildContext context) {
  if (task.startTime != null && task.endTime != null) {
    return '${task.startTime!.format(context)} - ${task.endTime!.format(context)}';
  } else if (task.startTime != null) {
    return 'Starts at ${task.startTime!.format(context)}';
  } else if (task.endTime != null) {
    return 'Ends at ${task.endTime!.format(context)}';
  }
  return '';
}
