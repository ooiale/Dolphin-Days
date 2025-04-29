import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

/// A confirmation dialog for deleting tasks with dangerous action safeguards.
///
class TaskDeleteDialog extends StatelessWidget {
  final TaskClass task;
  final VoidCallback onDelete;

  const TaskDeleteDialog({
    super.key,
    required this.task,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardDark,
      shape: _dialogShape(),
      alignment: Alignment.center,
      contentPadding: AppTheme.dialogButtonPadding,
      title: _buildTitle(),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  ShapeBorder _dialogShape() {
    return RoundedRectangleBorder(
      borderRadius: AppTheme.dialogBorderRadius,
      side: BorderSide(
        color: AppTheme.dialogDangerBorder,
        width: AppTheme.dialogBorderWidth,
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.warning_rounded,
            color: AppTheme.dangerIconColor, 
            size: AppTheme.dialogIconSize, 
          ),
          const SizedBox(height: AppTheme.smallSpacing), 
          Text(
            'Delete Task?',
            style: AppTextFonts.boldWhiteTextStyle.copyWith(
              fontSize: AppTheme.dialogTitleSize, 
              color: AppTheme.dangerTextLight, 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'You are about to delete:',
          style: AppTextFonts.boldWhiteTextStyle.copyWith(
            fontSize: AppTheme.dialogContentSize, 
            color: AppTheme.secondaryText, 
          ),
        ),
        const SizedBox(height: AppTheme.defaultSpacing), 
        Container(
          padding: AppTheme.dialogContentPadding, 
          decoration: BoxDecoration(
            color: AppTheme.dialogContentBackground, 
            borderRadius: AppTheme.contentBorderRadius, 
          ),
          child: Text(
            task.description,
            style: AppTextFonts.boldWhiteTextStyle.copyWith(
              fontSize: AppTheme.dialogContentSize, 
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        style: _cancelButtonStyle(),
        child: Text('Cancel', style: AppTextFonts.boldWhiteTextStyle),
      ),
      TextButton(
        onPressed: () {
          onDelete();
          Navigator.pop(context);
        },
        style: _deleteButtonStyle(),
        child: Text(
          'Delete',
          style: AppTextFonts.boldWhiteTextStyle.copyWith(
            color: AppTheme.dangerText, 
          ),
        ),
      ),
    ];
  }

  ButtonStyle _cancelButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppTheme.secondaryText, 
      padding: AppTheme.dialogButtonPadding, 
    );
  }

  ButtonStyle _deleteButtonStyle() {
    return TextButton.styleFrom(
      backgroundColor: AppTheme.dangerBackground, 
      foregroundColor: AppTheme.dangerText, 
      padding: AppTheme.dialogButtonPadding, 
      side: BorderSide(
        color: AppTheme.dangerBorder, 
        width: AppTheme.dialogBorderWidth, 
      ),
    );
  }
}
