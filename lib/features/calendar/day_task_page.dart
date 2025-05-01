import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/views/widgets/task_widgets/tasks_list_view.dart';
import 'package:dolphin_days/views/pages/tasks/add_task_page.dart';
import 'package:dolphin_days/data/themes/app_theme.dart';

// Shared underwater gradient matching TaskListPage
const _underwaterGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF1B2A49), // Deep ocean
    Color(0xFF3A8DAF), // Mid-water
    Color(0xFFB4E1E8), // Surface
  ],
);

/// Scaffold wrapper applying underwater gradient + bubble Lottie
class _UnderwaterScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  const _UnderwaterScaffold({
    this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(gradient: _underwaterGradient),
          ),

          // Bubble overlay
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

          // Page content
          SafeArea(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Shows all tasks for a specific day with underwater theme
class DayTasksPage extends StatelessWidget {
  final DateTime date;

  const DayTasksPage({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('EEEE, MMMM d').format(date);

    return _UnderwaterScaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: _underwaterGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ValueListenableBuilder<Box<TaskClass>>(
          valueListenable: HiveService.tasksBox.listenable(),
          builder: (context, box, _) {
            final normalized = DateTime(date.year, date.month, date.day);
            final tasksForDate =
                box.values.where((t) {
                  return t.date.year == normalized.year &&
                      t.date.month == normalized.month &&
                      t.date.day == normalized.day;
                }).toList();

            if (tasksForDate.isEmpty) {
              return Center(
                child: Text(
                  'No tasks for this day',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AppTheme.defaultFontSize,
                  ),
                ),
              );
            }

            return TasksListView(
              tasks: tasksForDate,
              onTaskUpdated: (task, value) {
                task.isCompleted = value ?? false;
                HiveService.updateTask(task);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withAlpha(80),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddTaskPage(initialDate: date)),
            ),
        child: const Icon(Icons.add, color: Color(0xFF1B2A49)),
      ),
    );
  }
}
