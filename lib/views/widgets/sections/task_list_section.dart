import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/utils/task_utils.dart';
import 'package:dolphin_days/views/widgets/sections/date_header.dart';
import 'package:dolphin_days/views/widgets/cards/task_card.dart';
import 'package:flutter/material.dart';

class TaskListSection extends StatelessWidget {
  final DateTime date;
  final List<TaskClass> tasks;
  final Function(TaskClass, bool?) onTaskUpdated;

  const TaskListSection({
    super.key,
    required this.date,
    required this.tasks,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final allCompleted = allTasksCompleted(tasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateHeader(date: date, allTasksCompleted: allCompleted),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children:
                tasks
                    .map(
                      (task) => TaskCard(
                        task: task,
                        onCheckboxChanged:
                            (value) => onTaskUpdated(task, value),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
