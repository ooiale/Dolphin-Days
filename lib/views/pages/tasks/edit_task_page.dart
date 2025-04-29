import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/views/task_form_base.dart';

class EditTaskPage extends TaskFormBase {
  final TaskClass task;

  const EditTaskPage({super.key, required this.task})
    : super(initialTask: task);

  @override
  EditTaskPageState createState() => EditTaskPageState();
}

class EditTaskPageState extends TaskFormBaseState<EditTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: AppTheme.defaultPadding,
        child: buildForm(context),
      ),
    );
  }

  @override
  Future<void> saveTask() async {
    final updatedTask = widget.task.copyWith(
      description: descriptionController.text,
      date: selectedDate!,
      startTime: selectedStartTime,
      endTime: selectedEndTime,
      priority: selectedPriority,
      notes: notesController.text.isNotEmpty ? notesController.text : null,
    );

    try {
      await HiveService.updateTask(updatedTask);
      if (!mounted) return;
      Navigator.pop(context, true); // This makes .then((success)) receive true
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
    }
  }
}
