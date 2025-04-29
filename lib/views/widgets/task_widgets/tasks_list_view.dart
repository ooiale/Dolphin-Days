import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/utils/task_utils.dart';
import 'package:dolphin_days/views/widgets/sections/task_list_section.dart';
import 'package:flutter/material.dart';


// Main list view builder
class TasksListView extends StatelessWidget {
  final List<TaskClass> tasks;
  final Function(TaskClass, bool?) onTaskUpdated;

  const TasksListView({
    super.key,
    required this.tasks,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final groupedTasks = groupTasksByDate(tasks);
    final sortedDates = groupedTasks.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dateTasks = sortTasks(groupedTasks[date]!);
        
        return TaskListSection(
          date: date,
          tasks: dateTasks,
          onTaskUpdated: onTaskUpdated,
        );
      },
    );
  }
}