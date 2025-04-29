import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final double cellSize;
  final Color borderColor;
  final double borderWidth;
  final List<TaskClass> tasks;
  final DateTime day;
  final bool isToday;
  final Widget? indicator;

  const DayCell({
    super.key,
    required this.cellSize,
    required this.borderColor,
    required this.borderWidth,
    required this.tasks,
    required this.day,
    required this.isToday,
    this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = tasks.where((t) => !t.isCompleted).toList();
    final Color dayTextColor = isToday ? Colors.blue : Colors.white;
    return Container(
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Stack(
        children: [
          // Task indicator (drawn first in the stack)
          if (indicator != null)
            if (incompleteTasks.isEmpty)
              // Centered indicator (e.g. logo or animation)
              Positioned.fill(child: indicator!)
            else
              // Bottom-left aligned counts indicator
              Positioned(bottom: 4, left: 4, child: indicator!),
          // Day number on top of the indicator
          Positioned(
            top: 4,
            right: 4,
            child: Text(
              '${day.day}',
              style: AppTextFonts.calendarDayTextStyle.copyWith(
                color: dayTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
