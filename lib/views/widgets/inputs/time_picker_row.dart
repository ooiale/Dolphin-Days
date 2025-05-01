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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$timeDescription:', style: AppTextFonts.boldGrayLabelStyle),
              const SizedBox(height: 4),
              Text(
                selectedTime != null
                    ? selectedTime!.format(context)
                    : 'Not selected',
                style:
                    selectedTime == null
                        ? AppTextFonts.boldWhiteTextStyle
                        : AppTextFonts.boldGreenTextStyle.copyWith(
                          fontSize: 22,
                        ),
              ),
            ],
          ),
        ),

        if (selectedTime != null)
          TextButton(
            onPressed: onClearTime,
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),

        TextButton(
          onPressed: onSelectTime,
          child: Text(
            selectedTime == null ? 'Select Time' : 'Change Time',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
