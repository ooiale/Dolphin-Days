import 'package:dolphin_days/data/themes/text_fonts.dart';
import 'package:dolphin_days/views/pages/tasks/add_task_page.dart';
import 'package:dolphin_days/features/calendar/calendar_page.dart';
import 'package:dolphin_days/views/pages/tasks/task_list_page.dart';
import 'package:flutter/material.dart';

class MainPageNavbar extends StatelessWidget {
  MainPageNavbar({super.key});

  final List pages = [
    CalendarPage(), //page 0
    AddTaskPage(), //page 1
    TaskListPage(), // page 2
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Calendar Button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pages[0]),
                  );
                },
              ),
              Text("Calendar", style: AppTextFonts.mainPageNavBarTextStyle),
            ],
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue, // Outline color
                    width: 2, // Outline thickness
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.add, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pages[1]),
                    );
                  },
                ),
              ),
              Text("Add Task", style: AppTextFonts.mainPageNavBarTextStyle),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.area_chart_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pages[2]),
                  );
                },
              ),
              Text("Tasks list", style: AppTextFonts.mainPageNavBarTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
