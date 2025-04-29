import 'package:dolphin_days/data/classes/dolphin_assignment.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:dolphin_days/data/services/dolphin_hive_service.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/views/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register ALL adapters upfront
  Hive.registerAdapter(TaskClassAdapter());
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(DolphinAssignmentAdapter());

  // Open boxes AFTER registration
  await HiveService.init();
  await DolphinHiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dolphin Days',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: WidgetTree(),
    );
  }
}
