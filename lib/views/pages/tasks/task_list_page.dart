import 'package:dolphin_days/data/themes/app_theme.dart';
import 'package:dolphin_days/data/enums/task_filter.dart';
import 'package:dolphin_days/utils/task_utils.dart';
import 'package:dolphin_days/views/pages/tasks/add_task_page.dart';
import 'package:dolphin_days/views/widgets/task_widgets/tasks_list_view.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:hive_flutter/adapters.dart';


class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
            icon: const Icon(Icons.filter_list, color: AppTheme.filterIconColor,),
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
