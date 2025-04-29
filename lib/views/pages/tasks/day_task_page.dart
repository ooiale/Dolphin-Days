import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/views/pages/tasks/add_task_page.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/views/widgets/task_widgets/tasks_list_view.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class DayTasksPage extends StatelessWidget {
  final DateTime date;

  const DayTasksPage({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DateFormat('EEEE, MMMM d').format(date))),
      body: ValueListenableBuilder(
        valueListenable: HiveService.tasksBox.listenable(),
        builder: (context, box, _) {
          final normalizedTargetDate = DateTime(
            date.year,
            date.month,
            date.day,
          );

          final tasksForDate =
              box.values
                  .where(
                    (task) =>
                        task.date.year == normalizedTargetDate.year &&
                        task.date.month == normalizedTargetDate.month &&
                        task.date.day == normalizedTargetDate.day,
                  )
                  .toList();

          return tasksForDate.isEmpty
              ? const Center(
                child: Text(
                  'No tasks for this day',
                  style: TextStyle(fontSize: AppTheme.defaultFontSize),
                ),
              )
              : TasksListView(
                tasks: tasksForDate,
                onTaskUpdated: (task, value) {
                  task.isCompleted = value ?? false;
                  HiveService.updateTask(task);
                },
              );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () async => await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskPage(initialDate: date),
              ),
            ),
        child: Icon(Icons.add),
      ),
    );
  }
}
