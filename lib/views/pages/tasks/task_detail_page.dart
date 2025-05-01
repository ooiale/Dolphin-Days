import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/views/pages/tasks/edit_task_page.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_date_card.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_priority_chip.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_status_header.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_time_card.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_property_card.dart';
import 'package:dolphin_days/views/widgets/task_widgets/task_delete_dialog.dart';

// Shared underwater gradient and scaffold wrapper
const _underwaterGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF1B2A49), // Deep ocean
    Color(0xFF3A8DAF), // Mid-water
    Color(0xFFB4E1E8), // Surface
  ],
);

class UnderwaterScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;

  const UnderwaterScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: Stack(
        children: [
          // 1) Gradient base
          Container(
            decoration: const BoxDecoration(gradient: _underwaterGradient),
          ),

          // 2) Bubble layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Lottie.asset(
                'assets/lotties/bubbles.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),

          // 3) Content
          SafeArea(child: body),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

/// Detailed view of a single task with underwater theming
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
    // Use underwater scaffold
    return UnderwaterScaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          TaskStatusHeader(task: task),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDescriptionCard(),
                  const SizedBox(height: 8),
                  _buildDateCard(context),
                  const SizedBox(height: 8),
                  if (task.startTime != null || task.endTime != null)
                    _buildTimeCards(context),
                  const SizedBox(height: 8),
                  _buildPropertiesRow(context),
                  if (task.notes?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    _buildNotesCard(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCompletionButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Task Details', style: AppTextFonts.boldWhiteTextStyle),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: _underwaterGradient),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => _navigateToEdit(context),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: AppTheme.warningRed),
          onPressed: () => _showDelete(context),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return TaskPropertyCard(
      color: Colors.black.withAlpha(166),
      label: 'Description',
      child: Text(task.description, style: AppTextFonts.boldWhiteTextStyle),
    );
  }

  Widget _buildDateCard(BuildContext context) {
    return TaskDateCard(
      context: context,
      date: task.date,
      label: 'Date',
      icon: Icons.calendar_today,
      color: Colors.black.withAlpha(166),
    );
  }

  Widget _buildTimeCards(BuildContext context) {
    return Row(
      children: [
        if (task.startTime != null)
          Expanded(
            child: TaskTimeCard(
              context: context,
              time: task.startTime!,
              label: 'Start Time',
              icon: Icons.access_time,
              color: Colors.black.withAlpha(166),
            ),
          ),
        if (task.endTime != null) const SizedBox(width: 8),
        if (task.endTime != null)
          Expanded(
            child: TaskTimeCard(
              context: context,
              time: task.endTime!,
              label: 'End Time',
              icon: Icons.timer_off,
              color: Colors.black.withAlpha(166),
            ),
          ),
      ],
    );
  }

  Widget _buildPropertiesRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TaskPropertyCard(
            color: Colors.black.withAlpha(166),
            label: 'Category',
            child: Chip(
              label: Text(task.category, style: AppTheme.categoryTheme),
              backgroundColor: AppTheme.categoryBlueLight,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TaskPropertyCard(
            color: Colors.black.withAlpha(166),
            label: 'Priority',
            child: TaskPriorityChip(priority: task.priority, isLarge: false),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return TaskPropertyCard(
      color: Colors.black.withAlpha(166),
      label: 'Notes',
      icon: Icons.notes,
      child: Text(task.notes!, style: AppTextFonts.boldWhiteTextStyle),
    );
  }

  Widget _buildCompletionButton(BuildContext context) {
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
      decoration: BoxDecoration(color: Colors.transparent),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            shape: AppTheme.roundedButtonBorder,
            padding: AppTheme.buttonPadding,
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
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => TaskDeleteDialog(
            task: task,
            onDelete: () {
              HiveService.deleteTask(task.id);
              Navigator.pop(context);
            },
          ),
    );
  }

  void _toggleCompletion(BuildContext context) async {
    try {
      await HiveService.updateTask(
        task.copyWith(isCompleted: !task.isCompleted),
      );
    } catch (_) {}
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditTaskPage(task: task)),
    );
  }
}
