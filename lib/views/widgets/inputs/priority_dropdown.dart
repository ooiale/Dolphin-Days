import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

class PriorityDropdown extends StatelessWidget {
  final Priority selectedPriority;
  final Function(Priority?) onChanged;

  const PriorityDropdown({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Priority>(
      isDense: false,
      isExpanded: true,
      itemHeight: null,
      value: selectedPriority,
      onChanged: onChanged,
      items:
          Priority.values.map((Priority priority) {
            return DropdownMenuItem<Priority>(
              value: priority,
              child: Text(
                priority.toString().split('.').last,
                style: AppTextFonts.boldWhiteTextStyle,
              ),
            );
          }).toList(),
      selectedItemBuilder: (context) {
        return Priority.values.map((priority) {
          return Text(
            priority.name,
            style: AppTextFonts.boldBlackTextStyle.copyWith(
              color: AppTheme.priorityColors[priority],
              fontSize: 22,
            ),
          );
        }).toList();
      },

      decoration: InputDecoration(
        labelText: 'Priority',
        floatingLabelAlignment: FloatingLabelAlignment.start,
        labelStyle: AppTextFonts.boldGrayLabelStyle,
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
