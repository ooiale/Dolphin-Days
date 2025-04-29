import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:dolphin_days/utils/task_utils.dart';

/// Displays a task's status header with visual indicators.
///
/// Shows either "Completed" or "Pending" status with:
/// - Colored background based on task status
/// - Appropriate status icon
/// - Bottom border for visual separation
///
/// Usage:
/// ```dart
/// TaskStatusHeader(task: currentTask)
/// ```
class TaskStatusHeader extends StatelessWidget {
  final TaskClass task;

  const TaskStatusHeader({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.taskStatusPadding,
      decoration: BoxDecoration(
        color: getTaskColor(
          task,
        ).withValues(alpha: AppTheme.taskStatusBackgroundOpacity),
        border: Border(
          bottom: BorderSide(
            color: getTaskColor(
              task,
            ).withValues(alpha: AppTheme.taskStatusBorderOpacity),
            width: AppTheme.taskStatusBorderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            task.isCompleted ? Icons.check_circle : Icons.pending_actions,
            color: getTaskColor(task),
            size: AppTheme.taskStatusIconSize,
          ),
          const SizedBox(width: AppTheme.defaultSpacing),
          Expanded(
            child: Text(
              task.isCompleted ? 'Completed' : 'Pending',
              style: AppTextFonts.taskDescriptionStyle(getTaskColor(task)),
            ),
          ),
        ],
      ),
    );
  }
}
