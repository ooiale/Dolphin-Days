import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/views/task_form_base.dart';

// Shared underwater gradient and scaffold wrapper (matching AddTaskPage)
const _underwaterGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF4F42B5), // Ocean Blue
    Color(0xFF82E1E3), // Medium Sky Blue
    Color(0xFFD4F1F9), // Water
  ],
);

/// A Scaffold wrapper that draws the underwater background and bubble animation.
class UnderwaterScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  const UnderwaterScaffold({super.key, this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: Stack(
        children: [
          // 1) Gradient base (Ocean Blue → Sky Blue → Water)
          Container(
            decoration: const BoxDecoration(gradient: _underwaterGradient),
          ),
          // 2) Bubble animation overlay
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
          // 3) Content area
          SafeArea(child: body),
        ],
      ),
    );
  }
}

/// Page to edit an existing task, themed underwater.
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
    return UnderwaterScaffold(
      appBar: AppBar(
        title: const Text('Edit Task', style: AppTextFonts.boldWhiteTextStyle),
        backgroundColor: AppTheme.appBarSeaThemedColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: AppTheme.defaultPadding,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: buildForm(context),
        ),
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
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
    }
  }
}
