import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/utils/task_utils.dart';
import 'package:dolphin_days/views/widgets/sections/date_header.dart';
import 'package:dolphin_days/views/widgets/cards/task_card.dart';
import 'package:flutter/material.dart';

/// A section for tasks on a given date, styled with glassmorphic containers.
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
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(8),
            color: Colors.white.withAlpha(15),
            child: Column(
              children:
                  tasks.map((task) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TaskCard(
                        task: task,
                        onCheckboxChanged:
                            (value) => onTaskUpdated(task, value),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
