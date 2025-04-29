import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

class DatePickerRow extends StatelessWidget {
  final DateTime? selectedDate;
  final Function() onSelectDate;

  const DatePickerRow({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Date: ',
                style: AppTextFonts.boldGrayLabelStyle,
              ),
              TextSpan(
                text: selectedDate != null
                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                    : "Not selected",
                style: selectedDate != null
                    ? AppTextFonts.boldWhiteTextStyle
                    : AppTextFonts.boldGrayLabelStyle,
              ),
            ],
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: onSelectDate,
          child: Text('Select Date'),
        ),
      ],
    );
  }
}