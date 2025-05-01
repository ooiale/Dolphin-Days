import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/data/enums/task_filter.dart';
import 'package:dolphin_days/utils/task_utils.dart';
import 'package:dolphin_days/views/pages/tasks/add_task_page.dart';
import 'package:dolphin_days/views/widgets/task_widgets/tasks_list_view.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';

const underwaterGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF1B2A49), // Deep ocean
    Color(0xFF3A8DAF), // Mid-water
    Color(0xFFB4E1E8), // Surface
  ],
);

/// A Scaffold wrapper that draws the underwater background + Lottie layers.
class UnderwaterScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  const UnderwaterScaffold({
    this.appBar,
    required this.body,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: Stack(
        children: [
          // 1) Gradient base
          Container(
            decoration: const BoxDecoration(gradient: underwaterGradient),
          ),

          // 3) Bubble layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Lottie.asset(
                'assets/lotties/bubbles.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),

          // 4) Page content
          SafeArea(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  Widget build(BuildContext context) {
    return UnderwaterScaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
            icon: const Icon(
              Icons.filter_list,
              color: AppTheme.filterIconColor,
            ),
            iconSize: AppTheme.iconSizeLarge,
            itemBuilder: (context) {
              return [
                buildFilterMenuItem(
                  text: 'All Tasks',
                  filter: TaskFilter.all,
                  color: AppTheme.filterAllColor,
                  currentFilter: _currentFilter,
                ),
                buildFilterMenuItem(
                  text: 'Completed Only',
                  filter: TaskFilter.completed,
                  color: AppTheme.filterCompletedColor,
                  currentFilter: _currentFilter,
                ),
                buildFilterMenuItem(
                  text: 'Incomplete Only',
                  filter: TaskFilter.incomplete,
                  color: AppTheme.filterIncompleteColor,
                  currentFilter: _currentFilter,
                ),
              ];
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<TaskClass>>(
        valueListenable: HiveService.tasksBox.listenable(),
        builder: (context, box, _) {
          final tasks = box.values.toList();
          if (tasks.isEmpty) return Center(child: Text('No tasks yet!'));

          // Added filtering logic based on current selection
          final filteredTasks = filterTasks(tasks, _currentFilter);

          return TasksListView(
            tasks: filteredTasks,
            onTaskUpdated: (task, value) {
              task.isCompleted = value ?? false;
              HiveService.updateTask(task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () async => await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage()),
            ),
        child: Icon(Icons.add),
      ),
    );
  }
}
