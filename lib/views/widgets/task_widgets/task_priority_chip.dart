import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

/// A chip widget that displays task priority with visual indicators
///
/// [priority]: The priority level to display
/// [isLarge]: Whether to use larger sizing for the chip (defaults to false)
class TaskPriorityChip extends StatelessWidget {
  final Priority priority;
  final bool isLarge;

  const TaskPriorityChip({
    super.key,
    required this.priority,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.priorityColors[priority]!;

    return Chip(
      labelPadding: isLarge ? AppTheme.priorityChipLargePadding : null,
      label: Text(
        _getPriorityText(priority),
        style: AppTextFonts.boldWhiteTextStyle.copyWith(
          fontSize:
              isLarge
                  ? AppTheme.priorityChipTextSizeLarge
                  : AppTheme.priorityChipTextSizeSmall,
          color: color,
        ),
      ),
      backgroundColor: color.withValues(
        alpha: AppTheme.priorityChipBackgroundOpacity,
      ),
      side: BorderSide(color: color, width: AppTheme.chipBorderWidth),
      avatar: Icon(
        Icons.flag,
        size:
            isLarge
                ? AppTheme
                    .priorityChipIconSizeLarge // Changed
                : AppTheme.priorityChipIconSizeSmall, // Changed
        color: AppTheme.priorityColors[priority], // Changed
      ),
    );
  }

  String _getPriorityText(Priority priority) {
    return priority.toString().split('.').last.toUpperCase();
  }
}
