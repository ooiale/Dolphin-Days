import 'package:dolphin_days/views/pages/tasks/add_task_page.dart';
import 'package:dolphin_days/views/widgets/task_widgets/tasks_list_view.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/data/services/task_hive_service.dart';
import 'package:dolphin_days/data/classes/task_class.dart';
import 'package:hive_flutter/adapters.dart';

class UncompletedTasksPage extends StatelessWidget {
  const UncompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uncompleted Tasks')),
      body: ValueListenableBuilder<Box<TaskClass>>(
        valueListenable: HiveService.tasksBox.listenable(),
        builder: (context, box, _) {
          final allTasks = box.values.toList();
          final uncompletedTasks = allTasks.where((task) => !task.isCompleted).toList();
          
          if (uncompletedTasks.isEmpty) {
            return const Center(child: Text('No uncompleted tasks!'));
          }

          return TasksListView(
            tasks: uncompletedTasks,
            onTaskUpdated: (task, value) {
              task.isCompleted = value ?? false;
              HiveService.updateTask(task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTaskPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}