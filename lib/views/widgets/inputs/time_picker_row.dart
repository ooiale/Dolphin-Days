import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

class TimePickerRow extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final Function() onSelectTime;
  final Function()? onClearTime; // New callback for clearing
  final String timeDescription;

  const TimePickerRow({
    super.key,
    required this.selectedTime,
    required this.onSelectTime,
    required this.timeDescription,
    this.onClearTime, // Make it optional
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$timeDescription: ',
                style: AppTextFonts.boldGrayLabelStyle,
              ),
              TextSpan(
                text: selectedTime != null
                    ? selectedTime!.format(context)
                    : "Not selected",
                style: AppTextFonts.boldWhiteTextStyle,
              ),
            ],
          ),
        ),
        const Spacer(),
        if (selectedTime != null) // Show clear button only when time is selected
          TextButton(
            onPressed: onClearTime,
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: onSelectTime,
          child: Text(selectedTime == null ? 'Select Time' : 'Change Time'),
        ),
      ],
    );
  }
}