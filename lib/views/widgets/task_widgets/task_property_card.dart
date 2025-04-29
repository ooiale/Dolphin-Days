import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

/// A reusable card widget for displaying task properties with consistent styling.
///
class TaskPropertyCard extends StatelessWidget {
  final Color color;
  final String label;
  final Widget child;
  final IconData? icon;
  final double elevation;

  const TaskPropertyCard({
    super.key,
    required this.color,
    required this.label,
    required this.child,
    this.icon,
    this.elevation = AppTheme.cardElevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: const RoundedRectangleBorder(
        borderRadius: AppTheme.defaultBorderRadius,
      ),
      color: color,
      child: Container(
        padding: AppTheme.defaultPadding,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Row(
                children: [
                  Icon(
                    icon,
                    size: AppTheme.iconSizeSmall,
                    color: AppTheme.secondaryText,
                  ),
                  const SizedBox(width: AppTheme.smallSpacing),
                  Text(label, style: AppTextFonts.cardDescriptionStyle),
                ],
              )
            else
              Text(label, style: AppTextFonts.cardDescriptionStyle),
            const SizedBox(height: AppTheme.defaultSpacing),
            child,
          ],
        ),
      ),
    );
  }
}
