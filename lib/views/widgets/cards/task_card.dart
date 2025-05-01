import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:dolphin_days/utils/task_utils.dart';
import 'package:dolphin_days/utils/time_utils.dart';
import 'package:dolphin_days/views/pages/tasks/task_detail_page.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final TaskClass task;
  final Function(bool?) onCheckboxChanged;
  final Function()? onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onCheckboxChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final taskColor = getTaskColor(task);

    return Card(
      color: Colors.black.withAlpha(166),
      margin: EdgeInsets.only(top: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _navigateToTaskDetail(context),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            leading: Container(
              width: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: taskColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            title: Text(
              task.description,
              style: AppTextFonts.taskDescriptionStyle(taskColor),
            ),
            subtitle: Text(
              timeIntervalText(task, context),
              style: AppTextFonts.taskTimeStyle(taskColor),
            ),
            trailing: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  task.isCompleted = value ?? false;
                  HiveService.updateTask(task);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTaskDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailPage(taskId: task.id)),
    );
  }
}
