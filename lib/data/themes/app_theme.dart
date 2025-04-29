import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppTheme {
  // Colors
  static Color primaryDark = Colors.black;
  static Color cardDark = Colors.grey[900]!;
  static Color cardLight = Colors.white;
  static Color warningRed = Colors.red[400]!;
  static Color completeRedLight = Colors.red[100]!;
  static Color completeRedDark = Colors.red[800]!;
  static Color completeGreenLight = Colors.green[100]!;
  static Color completeGreenDark = Colors.green[800]!;
  static const Color categoryBlue = Color(0xFF1976D2); // ≈ Colors.blue[800]
  static const Color categoryBlueLight = Color(0xFFBBDEFB); // ≈ Colors.blue[70]
  static const Color primaryColor = Color(0xFF1976D2); // Material blue 700

  // Priority Colors
  static const Map<Priority, Color> priorityColors = {
    Priority.high: Colors.red,
    Priority.medium: Colors.orange,
    Priority.low: Colors.green,
  };

  // category card
  static const categoryTheme = TextStyle(
    fontSize: AppTheme.defaultFontSize,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  // Spacing
  static const EdgeInsets defaultPadding = EdgeInsets.all(16);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 16);
  static const double defaultSpacing = 16;
  static const double smallSpacing = 8;

  // Button Styles
  static final ButtonStyle completeButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  // Sizes
  static const double iconSizeSmall = 20;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 28;
  static const double chipHeight = 32;
  static const double defaultFontSize = 18;

  // Shapes
  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(12),
  );
  static const RoundedRectangleBorder roundedButtonBorder =
      RoundedRectangleBorder(borderRadius: defaultBorderRadius);
  static const BorderSide defaultBorderSide = BorderSide(width: 1);

  // Card Theme
  static const double cardElevation = 2;
  static Color cardColor(bool isDark) =>
      isDark ? Colors.grey[900]! : Colors.white;

  // add_task_page values
  static const String defaultCategory = "General";
  static const Color successSnackbar = Colors.green;
  static const Color errorSnackbar = Colors.red;

  // Dialog Theme
  static const Color dialogBackground = Color(0xFF212121);
  static const Color dialogContentBackground = Color(0xFF303030);
  static const EdgeInsets dialogPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 20,
  );
  static const EdgeInsets dialogContentPadding = EdgeInsets.all(12);
  static const EdgeInsets dialogButtonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );
  static const BorderRadius dialogBorderRadius = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius contentBorderRadius = BorderRadius.all(
    Radius.circular(8),
  );
  static const double dialogBorderWidth = 1.5;
  static const double dialogIconSize = 36;
  static const double dialogTitleSize = 20;
  static const double dialogContentSize = 14;

  // Danger Theme (for delete/destructive actions)
  static const Color dangerIconColor = Color(0xFFEF5350); // Red 400
  static const Color dangerTextLight = Color(0xFFEF9A9A); // Red 200
  static const Color dangerText = Color(0xFFEF5350); // Red 400
  static const Color dangerBorder = Color(0xFFD32F2F); // Red 700
  static const Color dangerBackground = Color(
    0x1AEF5350,
  ); // Red 400 with 10% opacity
  static const Color dialogDangerBorder = Color(0xFFD32F2F); // Red 700
  static const Color secondaryText = Color(0xFFBDBDBD);

  // Priority Chip Theme
  static const double priorityChipIconSizeSmall = 16;
  static const double priorityChipIconSizeLarge = 18;
  static const double priorityChipTextSizeSmall = 16;
  static const double priorityChipTextSizeLarge = 18;
  static const EdgeInsets priorityChipLargePadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const double priorityChipBackgroundOpacity = 0.2;
  static const double chipBorderWidth = 1;

  // Task Status Theme
  static const EdgeInsets taskStatusPadding = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  );
  static const double taskStatusIconSize = 28;
  static const double taskStatusBorderWidth = 1;
  static const double taskStatusBackgroundOpacity = 0.2;
  static const double taskStatusBorderOpacity = 0.3;

  // Task Time Theme
  static const double taskTimeTextSize = 18;

  // Filter Colors
  static const Color filterAllColor = Colors.blueAccent;
  static const Color filterCompletedColor = Colors.greenAccent;
  static const Color filterIncompleteColor = Colors.redAccent;
  static const Color unselectedFilterColor = Colors.grey;
  static const Color filterIconColor = Colors.white;

  // Calendar Colors
  static const Color calendarPastDay = Color(0xFFE0E0E0);
  static const Color calendarEmptyDay = Colors.white;
  static const Color calendarAllCompleted = Color(0xFFC8E6C9); // Light green
  static const Color calendarHasIncomplete = Color(0xFFFFCDD2); // Light red
  static const Color calendarFutureWithTasks = Color(
    0xFFFFF9C4,
  ); // Light yellow
  static const Color calendarToday = Color(0xFFFFF176); // Brighter yellow
  static const Color calendarDayText = Colors.black;
  static const Color calendarSelectedDay = Colors.blueAccent;
  static const Color calendarMoveMonth = Colors.white;

  // Calendar Text Styles
  static TextStyle calendarDayTextStyle(Color textColor) =>
      TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold);

  // Calendar Theme
  static const calendarAppBar = Color.fromARGB(255, 52, 58, 63);
  static const Color calendarHeaderColor = Colors.white;
  static const Color calendarFormatButtonColor = primaryColor;
  static const Color calendarFormatButtonTextColor = Colors.white;
  static const double calendarHeaderHeight = 32.0;
  static const EdgeInsets calendarHeaderPadding = EdgeInsets.symmetric(
    vertical: 8.0,
  );
  static const Color calendarWeekdayColor = Colors.blueAccent;
  static const Color calendarWeekendColor = Colors.greenAccent;

  // Day Styles
  static const Color calendarTodayBackground = Color(
    0xFFFFF176,
  ); // Material amber 300
  static const Color calendarSelectedDayColor = primaryColor;
  static const Color calendarRangeStartEndColor = primaryColor;
  static const Color calendarRangeColor = Color(0x551976D2);
  static const Color calendarDisabledDayColor = Color(0xFFE0E0E0);
  static const Color calendarWeekendDayColor = Colors.black87;
  static const Color calendarOutsideDayColor = Colors.grey;
  static const double calendarDayBorderRadius = 12.0;
  static const double calendarCellBorderWidth = 2.0;
  static const Color defaultCalendarCellBorderColor = Colors.transparent;
  static const Color todayCalendarCellBorderColor = Colors.blueAccent;
  static const Color selectedCalendarCellBorderColor = Colors.white;
  static const Color completedCalendarCellBorderColor = Colors.green;
  static const Color pendingCalendarCellBorderColor = Colors.yellow;
  static const Color redCalendarCellBorderColor = Colors.red;
  static const Color orangeCalendarCellBorderColor = Colors.orange;

  // Marker Styles
  static const Color calendarMarkerColor = primaryColor;
  static const double calendarMarkerSize = 6.0;
  static const double calendarMarkerSpacing = 1.0;
  static const EdgeInsets calendarMarkerMargin = EdgeInsets.only(bottom: 4.0);

  // Preview Panel
  static const Color calendarPreviewBackground = Colors.white;
  static const EdgeInsets calendarPreviewPadding = EdgeInsets.all(12.0);
  static const BorderRadius calendarPreviewBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(12.0),
    topRight: Radius.circular(12.0),
  );
  static const BoxShadow calendarPreviewShadow = BoxShadow(
    color: Colors.white12,
    blurRadius: 6.0,
    offset: Offset(0, -2),
  );

  // Dimensions
  static const double calendarCellHeight = 42.0;
  static const double calendarCellWidth = 42.0;
  static const double calendarRowHeight = 48.0;
  static const double calendarBorderWidth = 2.0;
  static const Color calendarBorderColor = Color(0xFFE0E0E0);

  // Animation
  static const Duration calendarAnimationDuration = Duration(milliseconds: 300);
  static const Curve calendarAnimationCurve = Curves.easeInOut;

  // Calendar style
  static CalendarStyle calendarStyle = CalendarStyle(
    outsideDaysVisible: false,
    defaultDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    todayDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    selectedDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(4),
      color: Colors.transparent,
    ),
    weekendDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    outsideDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    defaultTextStyle: AppTextFonts.calendarDayTextStyle.copyWith(
      color: Colors.white,
    ),
    weekendTextStyle: AppTextFonts.calendarDayTextStyle.copyWith(
      color: Colors.white,
    ),
    todayTextStyle: AppTextFonts.calendarDayTextStyle.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    selectedTextStyle: AppTextFonts.calendarDayTextStyle.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    outsideTextStyle: AppTextFonts.calendarDayTextStyle.copyWith(
      color: Colors.white,
    ),
    cellPadding: EdgeInsets.zero,
    cellAlignment: Alignment.topCenter,
  );

  static Widget calendarCheckmark = Center(
    child: Icon(Icons.check, color: Colors.green, size: 24),
  );
}
