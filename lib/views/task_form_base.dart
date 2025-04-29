import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/views/widgets/inputs/custom_text_field.dart';
import 'package:dolphin_days/views/widgets/inputs/date_picker_row.dart';
import 'package:dolphin_days/views/widgets/inputs/priority_dropdown.dart';
import 'package:dolphin_days/views/widgets/inputs/time_picker_row.dart';

// this class here is immutable just like the statefulWidget - which means data does not change
// widgets are immutable and we don't change them
abstract class TaskFormBase extends StatefulWidget {
  final TaskClass? initialTask;

  const TaskFormBase({super.key, this.initialTask});
}

// and in this class we have mutable data so we separate it from the StatefulWidget
// States are mutable and we dynamically change them
abstract class TaskFormBaseState<T extends TaskFormBase> extends State<T> {
  late final TextEditingController descriptionController;
  late DateTime? selectedDate;
  late TimeOfDay? selectedStartTime;
  late TimeOfDay? selectedEndTime;
  late Priority selectedPriority;
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    final initialTask = widget.initialTask;

    descriptionController = TextEditingController(
      text: initialTask?.description ?? '',
    );
    selectedDate = initialTask?.date ?? DateTime.now();
    selectedStartTime = initialTask?.startTime;
    selectedEndTime = initialTask?.endTime;
    selectedPriority = initialTask?.priority ?? Priority.medium;
    notesController = TextEditingController(text: initialTask?.notes ?? '');
  }

  @override
  void dispose() {
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        if (selectedEndTime != null &&
            _compareTimes(picked, selectedEndTime!) >= 0) {
          selectedEndTime = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('End time cleared as it must be after start time'),
            ),
          );
        }
      });
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final initialTime =
        selectedStartTime != null
            ? TimeOfDay(
              hour: selectedStartTime!.hour + 1,
              minute: selectedStartTime!.minute,
            )
            : TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? initialTime,
    );

    if (picked != null && picked != selectedEndTime) {
      if (selectedStartTime == null ||
          _compareTimes(picked, selectedStartTime!) > 0) {
        setState(() => selectedEndTime = picked);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
      }
    }
  }

  int _compareTimes(TimeOfDay a, TimeOfDay b) {
    if (a.hour != b.hour) return a.hour - b.hour;
    return a.minute - b.minute;
  }

  Widget buildForm(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.smallSpacing),
            CustomTextField(
              controller: descriptionController,
              labelText: 'Description*',
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            DatePickerRow(
              selectedDate: selectedDate,
              onSelectDate: () => selectDate(context),
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            TimePickerRow(
              selectedTime: selectedStartTime,
              onSelectTime: () => selectStartTime(context),
              timeDescription: "Start Time",
              onClearTime: () => setState(() => selectedStartTime = null),
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            TimePickerRow(
              selectedTime: selectedEndTime,
              onSelectTime: () => selectEndTime(context),
              timeDescription: "End Time",
              onClearTime: () => setState(() => selectedEndTime = null),
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            PriorityDropdown(
              selectedPriority: selectedPriority,
              onChanged: (Priority? newValue) {
                setState(() => selectedPriority = newValue!);
              },
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            CustomTextField(
              controller: notesController,
              labelText: 'Notes',
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            Center(
              child: SizedBox(
                width: 200, // Width you want
                height: 50, // Height you want
                child: ElevatedButton(
                  onPressed: _validateAndSave,
                  child: const Text(
                    'Save Task',
                    style: TextStyle(fontSize: AppTheme.defaultFontSize),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateFields() {
    if (descriptionController.text.isEmpty) {
      return 'Description is required';
    }
    if (selectedDate == null) {
      return 'Date is required';
    }
    return null;
  }

  void _validateAndSave() async {
    final error = _validateFields();
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    await saveTask();
  }

  @protected
  Future<void> saveTask();
}
