import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/data/classes/task_class.dart';

Map<DateTime, List<TaskClass>> groupTaskByDate(List<TaskClass> tasks) {
  Map<DateTime, List<TaskClass>> tasksByDate = {};
  for (final task in tasks) {
    // normalizing the time to 0:00:00
    final dateKey = DateTime(task.date.year, task.date.month, task.date.day);
    tasksByDate.putIfAbsent(dateKey, () => []).add(task);
  }
  return tasksByDate;
}

Color selectCalendarCellBorder({
  required DateTime day,
  required bool hasTasks,
  required bool allCompleted,
  required bool hasCompleted,
}) {
  // Normalize the dates by zeroing out the time components
  final today = DateTime.now();
  final normalizedToday = DateTime(today.year, today.month, today.day);
  final normalizedDay = DateTime(day.year, day.month, day.day);

  final bool isPast = normalizedDay.isBefore(normalizedToday);
  final bool isFuture = !isPast; // Including today + future

  if (allCompleted) {
    return AppTheme.completedCalendarCellBorderColor;
  } else if (isPast) {
    if (hasTasks) {
      if (!hasCompleted) {
        // For a past day with tasks and only incomplete tasks
        return AppTheme.redCalendarCellBorderColor;
      } else {
        // For a past day with both completed and incomplete tasks
        return AppTheme.orangeCalendarCellBorderColor;
      }
    }
  } else if (isFuture) {
    if (hasTasks) {
      // For a future day with pending tasks
      return AppTheme.pendingCalendarCellBorderColor;
    }
  }

  // Fallback to default border color for days with no tasks, etc.
  return AppTheme.defaultCalendarCellBorderColor;
}

(String assetPath, double scale) getRandomDolphinAsset() {
  final Map<String, double> dolphinAssetScales = {
    'assets/images/dolphins/happy/dolphin1.png': 0.77,
    'assets/images/dolphins/happy/dolphin2.png': 1.66,
    'assets/images/dolphins/happy/dolphin3.png': 1.66,
    'assets/images/dolphins/happy/dolphin4.png': 1.66,
    'assets/images/dolphins/happy/dolphin5.png': 1.66,
    'assets/images/dolphins/happy/dolphin6.png': 1.66,
    'assets/images/dolphins/happy/dolphin7.png': 1.66,
    'assets/images/dolphins/happy/dolphin8.png': 1.66,
    // Add more entries as needed
  };

  final random = Random();
  final assetPaths = dolphinAssetScales.keys.toList();
  final index = random.nextInt(assetPaths.length);
  final assetPath = assetPaths[index];
  final scale = dolphinAssetScales[assetPath]!;

  return (assetPath, scale);
}
