import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:flutter/material.dart';

class AppTextFonts {
  static const TextStyle boldGrayLabelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey,
  );
  static const TextStyle boldWhiteTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle boldBlackTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle boldGreenTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle cardDescriptionStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.grey,
  );
  static TextStyle taskDateStyle(bool allCompleted) => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: allCompleted ? const Color.fromARGB(255, 0, 255, 8) : Colors.red,
  );
  static TextStyle taskTimeStyle(Color taskColor) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: taskColor);
  static TextStyle taskDescriptionStyle(Color taskColor) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: taskColor);
  static TextStyle dropDownMenuStyle(Color taskColor) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: taskColor);

  // Calendar Text Styles
  static const TextStyle calendarHeaderTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle calendarDayTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle calendarSelectedDayTextStyle = TextStyle(
    fontSize: AppTheme.defaultFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle calendarTodayTextStyle = TextStyle(
    fontSize: AppTheme.defaultFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle calendarEventCountTextStyle = TextStyle(
    fontSize: AppTheme.defaultFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle calendarPreviewTitleStyle = TextStyle(
    fontSize: AppTheme.defaultFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle mainPageNavBarTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}
