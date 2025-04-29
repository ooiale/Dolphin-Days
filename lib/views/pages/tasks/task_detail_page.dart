import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/views/pages/tasks/edit_task_page.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_date_card.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_priority_chip.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_status_header.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_time_card.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_property_card.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_delete_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Task detail page that displays all information about a specific task
///
/// Uses [ValueListenableBuilder] to automatically update when task changes
class TaskDetailPage extends StatelessWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<TaskClass>>(
      valueListenable: HiveService.tasksBox.listenable(),
      builder: (context, box, _) {
        final task = box.get(taskId);
        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task Not Found')),
            body: const Center(child: Text('Task has been deleted')),
          );
        }
        return _TaskDetailContent(task: task);
      },
    );
  }
}

class _TaskDetailContent extends StatelessWidget {
  final TaskClass task;

  const _TaskDetailContent({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context, theme),
      body: Column(
        children: [
          TaskStatusHeader(task: task),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDescriptionCard(AppTheme.cardColor(isDarkMode)),
                  buildDateCard(context, AppTheme.cardColor(isDarkMode)),
                  if (task.startTime != null || task.endTime != null)
                    _buildTimeCards(context, AppTheme.cardColor(isDarkMode)),
                  _buildPropertiesRow(AppTheme.cardColor(isDarkMode)),
                  if (task.notes?.isNotEmpty ?? false)
                    _buildNotesCard(AppTheme.cardColor(isDarkMode)),
                ],
              ),
            ),
          ),
          _buildCompletionButton(context, theme),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Text('Task Details', style: AppTextFonts.boldWhiteTextStyle),
      backgroundColor: AppTheme.primaryDark,
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: theme.colorScheme.secondary),
          onPressed: () => _navigateToEdit(context),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: AppTheme.warningRed),
          onPressed:
              () => showDialog(
                context: context,
                builder:
                    (context) => TaskDeleteDialog(
                      task: task,
                      onDelete: () {
                        HiveService.deleteTask(task.id);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
              ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(Color cardColor) {
    return TaskPropertyCard(
      color: cardColor,
      label: 'Description',
      child: Text(task.description, style: AppTextFonts.boldWhiteTextStyle),
    );
  }

  Widget _buildTimeCards(BuildContext context, Color cardColor) {
    return Row(
      children: [
        if (task.startTime != null)
          Expanded(
            child: TaskTimeCard(
              context: context,
              time: task.startTime!,
              label: 'Start Time',
              icon: Icons.access_time,
              color: cardColor,
            ),
          ),
        if (task.endTime != null)
          Expanded(
            child: TaskTimeCard(
              context: context,
              time: task.endTime!,
              label: 'End Time',
              icon: Icons.timer_off,
              color: cardColor,
            ),
          ),
      ],
    );
  }

  Widget _buildPropertiesRow(Color cardColor) {
    return Row(
      children: [
        Expanded(
          child: TaskPropertyCard(
            color: cardColor,
            label: 'Category',
            child: Chip(
              label: Text(task.category, style: AppTheme.categoryTheme),
              backgroundColor: AppTheme.categoryBlueLight,
            ),
          ),
        ),
        Expanded(
          child: TaskPropertyCard(
            color: cardColor,
            label: 'Priority',
            child: TaskPriorityChip(priority: task.priority, isLarge: false),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard(Color cardColor) {
    return TaskPropertyCard(
      color: cardColor,
      label: 'Notes',
      icon: Icons.notes,
      child: Text(task.notes!, style: AppTextFonts.boldWhiteTextStyle),
    );
  }

  Widget _buildCompletionButton(BuildContext context, ThemeData theme) {
    final buttonColor =
        task.isCompleted
            ? AppTheme.completeRedLight
            : AppTheme.completeGreenLight;
    final textColor =
        task.isCompleted
            ? AppTheme.completeRedDark
            : AppTheme.completeGreenDark;

    return Container(
      padding: AppTheme.defaultPadding,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: AppTheme.defaultBorderSide),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          key: const Key('complete_button'),
          style: ElevatedButton.styleFrom(
            padding: AppTheme.buttonPadding,
            shape: AppTheme.roundedButtonBorder,
            backgroundColor: buttonColor,
            foregroundColor: textColor,
          ),
          onPressed: () => _toggleCompletion(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                task.isCompleted ? Icons.undo : Icons.check,
                size: AppTheme.iconSizeSmall,
              ),
              const SizedBox(width: 8),
              Text(
                task.isCompleted ? 'Mark Incomplete' : 'Mark Complete',
                style: AppTextFonts.boldWhiteTextStyle.copyWith(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Consider adding error handling for Hive operations
  void _toggleCompletion(BuildContext context) async {
    try {
      await HiveService.updateTask(
        task.copyWith(isCompleted: !task.isCompleted),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: ${e.toString()}')),
      );
    }
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskPage(task: task)),
    ).then((success) {
      if (success == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully')),
        );
      }
    });
  }

  Widget buildDateCard(BuildContext context, Color cardColor) {
    return TaskDateCard(
      context: context,
      date: task.date,
      label: 'Date',
      icon: Icons.calendar_today,
      color: cardColor,
    );
  }
}
