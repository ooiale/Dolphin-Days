import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/views/widgets/inputs/custom_text_field.dart';
import 'package:dolphin_days/views/widgets/inputs/date_picker_row.dart';
import 'package:dolphin_days/views/widgets/inputs/priority_dropdown.dart';
import 'package:dolphin_days/views/widgets/inputs/time_picker_row.dart';

abstract class TaskFormBase extends StatefulWidget {
  final TaskClass? initialTask;

  const TaskFormBase({super.key, this.initialTask});
}

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
    descriptionController.addListener(() {
      setState(() {});
    });

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
    FocusScope.of(context).requestFocus(FocusNode()); // remove focus from keyboard if it was previously focused
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
    FocusScope.of(context).requestFocus(FocusNode());
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
    FocusScope.of(context).requestFocus(FocusNode());
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

  bool get _isFormValid =>
      descriptionController.text.isNotEmpty && selectedDate != null;

  Widget buildForm(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        padding: AppTheme.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.smallSpacing),

            // 1) Description
            CustomTextField(
              controller: descriptionController,
              labelText: 'Description*',
            ),
            const SizedBox(height: AppTheme.smallSpacing),

            // 2) Date picker
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: DatePickerRow(
                selectedDate: selectedDate,
                onSelectDate: () => selectDate(context),
              ),
            ),
            const SizedBox(height: AppTheme.smallSpacing),

            // 3) Start time picker
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TimePickerRow(
                selectedTime: selectedStartTime,
                timeDescription: 'Start Time',
                onSelectTime: () => selectStartTime(context),
                onClearTime: () => setState(() => selectedStartTime = null),
              ),
            ),
            const SizedBox(height: AppTheme.smallSpacing),

            // 4) End time picker
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TimePickerRow(
                selectedTime: selectedEndTime,
                timeDescription: 'End Time',
                onSelectTime: () => selectEndTime(context),
                onClearTime: () => setState(() => selectedEndTime = null),
              ),
            ),
            const SizedBox(height: AppTheme.defaultSpacing),

            // 5) Priority dropdown
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
              ),
              child: PriorityDropdown(
                selectedPriority: selectedPriority,
                onChanged: (Priority? newValue) {
                  setState(() => selectedPriority = newValue!);
                },
              ),
            ),
            const SizedBox(height: AppTheme.defaultSpacing),

            // 6) Notes
            CustomTextField(
              controller: notesController,
              labelText: 'Notes',
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.defaultSpacing),

            // 7) Save button
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _validateAndSave,
                  child: Text(
                    'Save Task',
                    style: TextStyle(
                      fontSize: _isFormValid ? 20 : AppTheme.defaultFontSize,
                      color:
                          _isFormValid
                              ? const Color.fromARGB(255, 0, 255, 8)
                              : null,
                      fontWeight: _isFormValid ? FontWeight.bold : null,
                    ),
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
