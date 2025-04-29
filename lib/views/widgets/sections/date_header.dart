import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:dolphin_days/utils/date_utils.dart';
import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  final DateTime date;
  final bool allTasksCompleted;

  const DateHeader({
    super.key,
    required this.date,
    required this.allTasksCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        )),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        formatDateReadable(date),
        style: AppTextFonts.taskDateStyle(allTasksCompleted),
      ),
    );
  }
}