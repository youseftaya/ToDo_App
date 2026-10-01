import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/data/model/task_model.dart';
import 'package:untitled/view/screens/add_task_screen.dart';
import 'package:untitled/view/widgets/task_card.dart';

enum TaskCategory {
  today,
  overdue,
  upcoming,
}

class TaskCategoryScreen extends StatelessWidget {
  final TaskCategory category;

  const TaskCategoryScreen({
    super.key,
    required this.category,
  });

  String get title {
    switch (category) {
      case TaskCategory.today:
        return "Today's Tasks";
      case TaskCategory.overdue:
        return 'Overdue Tasks';
      case TaskCategory.upcoming:
        return 'Upcoming Tasks';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isOverdue(TaskModel task) {
    if (task.dueDate == null ||
        task.status == StatusTask.done) {
      return false;
    }

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final dueDate = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
    );

    return dueDate.isBefore(today);
  }

  bool _isUpcoming(TaskModel task) {
    if (task.dueDate == null) {
      return false;
    }

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final dueDate = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
    );

    return dueDate.isAfter(today);
  }

  List<TaskModel> _getTasks(List<TaskModel> tasks) {
    final now = DateTime.now();

    switch (category) {
      case TaskCategory.today:
        return tasks.where((task) {
          if (task.dueDate == null) {
            return false;
          }

          return _isSameDay(
            task.dueDate!,
            now,
          );
        }).toList();

      case TaskCategory.overdue:
        return tasks.where(_isOverdue).toList();

      case TaskCategory.upcoming:
        return tasks.where(_isUpcoming).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<TaskModel>('Tasks');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (
          context,
          Box<TaskModel> box,
          _,
        ) {
          final tasks = _getTasks(
            box.values.toList(),
          );

          if (tasks.isEmpty) {
            return Center(
              child: Text(
                category == TaskCategory.today
                    ? '🎉 No tasks for today'
                    : category == TaskCategory.overdue
                        ? '🎉 No overdue tasks'
                        : '📅 No upcoming tasks',
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskCard(
                task: task,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(
                        task: task,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}