import 'package:dolphin_days/data/dolphin_asset_manager.dart';
import 'package:dolphin_days/data/classes/dolphin_assignment.dart';
import 'package:dolphin_days/utils/calendar_utils.dart';
import 'package:dolphin_days/views/widgets/calendar/day_cell.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dolphin_days/views/pages/tasks/day_task_page.dart';
import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  late DateTime focusedDay;
  DateTime? selectedDay;
  late Map<DateTime, List<TaskClass>> tasksByDate;
  late CalendarFormat calendarFormat;

  final DolphinAssetManager dolphinAssetManager = DolphinAssetManager();
  // get the Hive box for persistent storage.
  late Box<DolphinAssignment> dolphinAssignmentsBox;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    focusedDay = now;
    selectedDay = now;
    tasksByDate = {};
    calendarFormat = CalendarFormat.month;
    dolphinAssignmentsBox = Hive.box<DolphinAssignment>('dolphinAssignments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar', style: AppTextFonts.boldWhiteTextStyle),
        backgroundColor: AppTheme.calendarAppBar,
      ),
      body: ValueListenableBuilder<Box<TaskClass>>(
        valueListenable: HiveService.tasksBox.listenable(),
        builder: (context, box, _) {
          tasksByDate = groupTaskByDate(box.values.toList());
          return buildFullScreenCalendar(context);
        },
      ),
    );
  }

  Widget buildFullScreenCalendar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cellSize = (screenWidth / 7).floorToDouble();
    // final rowHeight = cellSize * 1.55; unused because of shouldFillViewport = true

    return TableCalendar<TaskClass>(
      daysOfWeekHeight: AppTheme.calendarHeaderHeight,
      sixWeekMonthsEnforced: true,
      shouldFillViewport: true, // fill empty space
      firstDay: DateTime(DateTime.now().year - 1, 1, 1),
      lastDay: DateTime(DateTime.now().year + 1, 12, 31),
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      calendarFormat: calendarFormat,
      onFormatChanged: (format) => setState(() => calendarFormat = format),
      onDaySelected: (newSelectedDay, newFocusedDay) {
        setState(() {
          selectedDay = newSelectedDay;
          focusedDay = newFocusedDay;
        });
        openDayTasks(newSelectedDay);
      },
      onPageChanged: (newFocusedDay) => focusedDay = newFocusedDay,
      eventLoader:
          (day) => tasksByDate[DateTime(day.year, day.month, day.day)] ?? [],

      calendarBuilders: CalendarBuilders(
        defaultBuilder:
            (context, day, focusedDay) => buildDayCell(day, cellSize: cellSize),
        todayBuilder:
            (context, day, focusedDay) =>
                buildDayCell(day, isToday: true, cellSize: cellSize),
        selectedBuilder: (context, day, focusedDay) {
          final isToday = isSameDay(day, DateTime.now());
          return buildDayCell(
            day,
            isSelected: true,
            isToday: isToday,
            cellSize: cellSize,
          );
        },
        markerBuilder:
            (context, date, events) =>
                const SizedBox.shrink(), // Disables default markers
      ),

      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: AppTextFonts.calendarHeaderTextStyle,
        leftChevronIcon: const Icon(
          Icons.chevron_left,
          color: AppTheme.calendarMoveMonth,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right,
          color: AppTheme.calendarMoveMonth,
        ),
        headerPadding: AppTheme.calendarHeaderPadding,
      ),

      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: AppTextFonts.calendarDayTextStyle.copyWith(
          color: AppTheme.calendarWeekdayColor,
        ),
        weekendStyle: AppTextFonts.calendarDayTextStyle.copyWith(
          color: AppTheme.calendarWeekendColor,
        ),
      ),

      calendarStyle: AppTheme.calendarStyle,
    );
  }

  Widget buildDayCell(
    DateTime day, {
    bool isToday = false,
    bool isSelected = false,
    bool isOutside = false,
    required double cellSize,
  }) {
    final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    final tasks = tasksByDate[normalizedDay] ?? [];
    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    final incompleteTasks = tasks.where((t) => !t.isCompleted).toList();
    double borderWidth = AppTheme.calendarBorderWidth;
    Color borderColor;

    borderColor = selectCalendarCellBorder(
      day: day,
      hasTasks: tasks.isNotEmpty,
      allCompleted: tasks.isNotEmpty && incompleteTasks.isEmpty,
      hasCompleted: completedTasks.isNotEmpty,
    );

    // select what will be displayed inside the day's cell
    Widget? indicator;
    if (tasks.isNotEmpty) {
      if (incompleteTasks.isEmpty) {
        // Use the normalized date as a key (using toIso8601String as a simple key)
        String key = normalizedDay.toIso8601String();
        DolphinAssignment? assignment = dolphinAssignmentsBox.get(key);

        if (assignment == null) {
          // If there’s no assignment yet, get the next asset from the asset manager
          final (String assetPath, double scale) =
              dolphinAssetManager.getNextAsset();

          assignment = DolphinAssignment(assetPath: assetPath, scale: scale);
          // Save the new assignment to Hive for persistence.
          dolphinAssignmentsBox.put(key, assignment);
        }

        final String assetPath = assignment.assetPath;
        final double scale = assignment.scale;

        indicator = Transform.scale(
          scale: scale,
          child: Image.asset(assetPath, fit: BoxFit.contain),
        );
      } else {
        // Show counts of completed and incomplete tasks
        indicator = Column(
          children: [
            if (completedTasks.isNotEmpty)
              Text(
                '${completedTasks.length} ✓',
                style: AppTheme.calendarDayTextStyle(Colors.greenAccent),
              ),
            if (incompleteTasks.isNotEmpty)
              Text(
                '${incompleteTasks.length} ✗',
                style: AppTheme.calendarDayTextStyle(Colors.redAccent),
              ),
          ],
        );
      }
    }

    return DayCell(
      cellSize: cellSize,
      borderColor: borderColor,
      borderWidth: borderWidth,
      tasks: tasks,
      day: day,
      isToday: isToday,
      indicator: indicator,
    );
  }

  void openDayTasks(DateTime date) {
    // normalized date to 0:00:00
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DayTasksPage(date: date)),
    );
  }
}
