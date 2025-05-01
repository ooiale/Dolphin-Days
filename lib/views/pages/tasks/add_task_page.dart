import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // add lottie package
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/app_theme.dart';
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
    return GestureDetector(
      behavior:
          HitTestBehavior.translucent, // lets taps “fall through” to children
      onTap:
          () =>
              FocusScope.of(
                context,
              ).unfocus(), // hides keyboard on any tap outside
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Task', style: AppTextFonts.boldWhiteTextStyle),
          backgroundColor: AppTheme.appBarSeaThemedColor,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30.0, // Set your desired icon size
          ),
        ),

        // 1) Underwater gradient background
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(
                  0xFF4F42B5,
                ), // Ocean Blue :contentReference[oaicite:0]{index=0}
                Color(
                  0xFF82E1E3,
                ), // Medium Sky Blue :contentReference[oaicite:1]{index=1}
                Color(
                  0xFFD4F1F9,
                ), // Water :contentReference[oaicite:2]{index=2}
              ],
            ),
          ),
          child: Stack(
            children: [
              // 2) Subtle bubble animation layer
              Positioned.fill(
                child: Opacity(
                  opacity: 0.3,
                  child: Lottie.asset(
                    'assets/lotties/bubbles.json',
                    fit: BoxFit.cover,
                  ), // bubbles animation example :contentReference[oaicite:3]{index=3}
                ),
              ),

              // 3) The scrollable form in a translucent “card”
              SafeArea(
                child: SingleChildScrollView(
                  padding: AppTheme.defaultPadding,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(
                        50,
                      ), // semi-transparent card :contentReference[oaicite:4]{index=4}
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: buildForm(context),
                  ),
                ),
              ),
            ],
          ),
        ),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task saved successfully!')));
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
