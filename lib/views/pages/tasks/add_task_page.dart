import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/views/task_form_base.dart';

class AddTaskPage extends TaskFormBase {
  const AddTaskPage({super.key, this.initialDate});
  final DateTime? initialDate;

  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends TaskFormBaseState<AddTaskPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      selectedDate = widget.initialDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: AppTheme.defaultPadding,
        child: buildForm(context),
      ),
    );
  }

  @override
  Future<void> saveTask() async {
    final newTask = TaskClass(
      description: descriptionController.text,
      date: selectedDate!,
      startTime: selectedStartTime,
      endTime: selectedEndTime,
      priority: selectedPriority,
      category: "General",
      notes: notesController.text.isNotEmpty ? notesController.text : null,
    );

    try {
      await HiveService.addTask(newTask);
      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task saved successfully!')));

      // Clear only specific fields (maintains date and priority)
      setState(() {
        descriptionController.clear();
        selectedStartTime = null;
        selectedEndTime = null;
        notesController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save task: $e')));
    }
  }
}
