import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:intl/intl.dart';

/// A card widget for displaying date information with consistent styling.
///
/// Features:
/// - Shows date details with day-of-week and formatted date
/// - Displays a label and a blue icon
/// - Customizable color scheme, padding, and elevation
/// - Consistent design with TaskTimeCard
///
/// Usage:
/// ```dart
/// TaskDateCard(
///   context: context,
///   date: task.date,
///   label: 'Date',
///   icon: Icons.calendar_today,
///   color: AppTheme.someCardColor,
/// )
/// ```
class TaskDateCard extends StatelessWidget {
  final BuildContext context;
  final DateTime date;
  final String label;
  final IconData icon;
  final Color color;

  const TaskDateCard({
    super.key,
    required this.context,
    required this.date,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.cardElevation,
      shape: RoundedRectangleBorder(borderRadius: AppTheme.defaultBorderRadius),
      color: color,
      child: Padding(
        padding: AppTheme.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: AppTheme.iconSizeSmall,
                  color: AppTheme.categoryBlue,
                ),
                const SizedBox(width: AppTheme.smallSpacing),
                Text(label, style: AppTextFonts.cardDescriptionStyle),
              ],
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            Row(
              children: [
                Text(
                  DateFormat('EEEE, MMMM d - y').format(date),
                  style: AppTextFonts.boldWhiteTextStyle.copyWith(
                    fontSize: AppTheme.taskTimeTextSize,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
