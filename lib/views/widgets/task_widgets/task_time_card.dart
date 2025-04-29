import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

/// A card widget for displaying time information with consistent styling.
///
/// Features:
/// - Shows time with label and icon
/// - Customizable color scheme
/// - Standardized padding and elevation
/// - Responsive layout
///
/// Usage:
/// ```dart
/// TaskTimeCard(
///   context: context,
///   time: task.dueTime,
///   label: 'Due Time',
///   icon: Icons.access_time,
///   color: AppTheme.categoryBlueLight,
/// )
/// ```
class TaskTimeCard extends StatelessWidget {
  final BuildContext context;
  final TimeOfDay time;
  final String label;
  final IconData icon;
  final Color color;

  const TaskTimeCard({
    super.key,
    required this.context,
    required this.time,
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
            Text(
              time.format(context),
              style: AppTextFonts.boldWhiteTextStyle.copyWith(
                fontSize: AppTheme.taskTimeTextSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
