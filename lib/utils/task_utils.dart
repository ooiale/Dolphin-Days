import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/enums/task_filter.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:dolphin_days/utils/time_utils.dart';
import 'package:flutter/material.dart';

// From saveTask()
String? validateTaskFields({
  required String description,
  required DateTime? date,
}) {
  if (description.isEmpty) return 'Description is required';
  if (date == null) return 'Date is required';
  return null;
}

// Check if all tasks in a list are completed
bool allTasksCompleted(List<TaskClass> tasks) {
  return tasks.every((task) => task.isCompleted);
}

Color getTaskColor(TaskClass task) {
  if (task.isCompleted) return Colors.green;

  final nowTime = TimeOfDay.now();
  final now = DateTime.now();
  final taskDate = task.date;

  // Normalize dates to midnight for comparison
  final today = DateTime(now.year, now.month, now.day);
  final taskDay = DateTime(taskDate.year, taskDate.month, taskDate.day);

  // Check if task date is in the past
  if (taskDay.isBefore(today)) {
    return Colors.red; // Overdue from previous day
  }

  // Check if task date is today
  if (taskDay == today) {
    if (task.startTime != null && task.endTime != null) {
      final startComparison = compareTimes(task.startTime!, nowTime);
      final endComparison = compareTimes(task.endTime!, nowTime);

      // Task is happening now (start <= now <= end)
      if (startComparison <= 0 && endComparison >= 0) {
        return Colors.orange;
      }

      // Task is overdue (end time passed)
      if (endComparison < 0) {
        return Colors.red;
      }

      // Task is upcoming (start time in future)
      if (startComparison > 0) {
        return Colors.yellowAccent;
      }
    }
    // ... rest of your logic for other cases
  }

  return Colors.yellowAccent; // Future task or no time specified
}

Map<DateTime, List<TaskClass>> groupTasksByDate(List<TaskClass> tasks) {
  final grouped = <DateTime, List<TaskClass>>{};
  for (final task in tasks) {
    final date = DateTime(task.date.year, task.date.month, task.date.day);
    grouped.putIfAbsent(date, () => []).add(task);
  }
  return grouped;
}

List<TaskClass> sortTasks(List<TaskClass> tasks) {
  return tasks..sort((a, b) {
    // First group: Tasks with end times (sorted by end time descending)
    if (a.endTime != null && b.endTime != null) {
      return compareTimes(b.endTime!, a.endTime!); // Note reversed order
    }
    if (a.endTime != null) return -1; // a has end time, comes first
    if (b.endTime != null) return 1; // b has end time, comes first

    // Second group: Tasks with only start times (sorted by start time descending)
    if (a.startTime != null && b.startTime != null) {
      return compareTimes(b.startTime!, a.startTime!); // Note reversed order
    }
    if (a.startTime != null) return -1; // a has start time, comes first
    if (b.startTime != null) return 1; // b has start time, comes first

    // Third group: Tasks with no times specified (order doesn't matter)
    return 0;
  });
}

List<TaskClass> filterTasks(List<TaskClass> tasks, TaskFilter filter) {
  switch (filter) {
    case TaskFilter.completed:
      return tasks.where((task) => task.isCompleted).toList();
    case TaskFilter.incomplete:
      return tasks.where((task) => !task.isCompleted).toList();
    case TaskFilter.all:
      return tasks;
  }
}

PopupMenuItem<TaskFilter> buildFilterMenuItem({
  required String text,
  required TaskFilter filter,
  required Color color,
  required TaskFilter currentFilter,
}) {
  final textColor =
      currentFilter == filter ? color : AppTheme.unselectedFilterColor;
  return PopupMenuItem<TaskFilter>(
    value: filter,
    child: Text(text, style: AppTextFonts.dropDownMenuStyle(textColor)),
  );
}

