import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/data/model/task_model.dart';
import 'package:untitled/data/model/user_model.dart';

import '../widgets/home_header.dart';
import '../widgets/task_statistics.dart';
import '../screens/task_category_screen.dart';
import '../screens/add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 125,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withOpacity(0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 21,
                ),
              ),

              const Spacer(),

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 2),

              Row(
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.brightness ==
                                Brightness.dark
                            ? Colors.grey.shade400
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Box<TaskModel> taskBox =
        Hive.box<TaskModel>('Tasks');

    final Box<UserModel> userBox =
        Hive.box<UserModel>('User');

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: taskBox.listenable(),
          builder: (
            context,
            Box<TaskModel> box,
            _,
          ) {
            final tasks = box.values.toList();

            final doneTasks = tasks
                .where(
                  (task) =>
                      task.status == StatusTask.done,
                )
                .length;

            final pendingTasks = tasks
                .where(
                  (task) =>
                      task.status == StatusTask.pending,
                )
                .length;

            final now = DateTime.now();

            final todayTasks = tasks.where(
              (task) {
                if (task.dueDate == null) {
                  return false;
                }

                return _isSameDay(
                  task.dueDate!,
                  now,
                );
              },
            ).toList();

            final overdueTasks = tasks
                .where(_isOverdue)
                .toList();

            final upcomingTasks = tasks
                .where(_isUpcoming)
                .toList();

            return ValueListenableBuilder(
              valueListenable: userBox.listenable(),
              builder: (
                context,
                Box<UserModel> userBox,
                _,
              ) {
                final user = userBox.get('user');

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      HomeHeader(
                        imageBytes: user?.imageBytes,
                      ),

                      const SizedBox(height: 24),

                      TaskStatistics(
                        totalTasks: tasks.length,
                        doneTasks: doneTasks,
                        pendingTasks: pendingTasks,
                      ),

                      const SizedBox(height: 28),

                      Text(
                        'Task Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // First row
                      Row(
                        children: [
                          _buildCategoryCard(
                            context: context,
                            title: 'Today',
                            subtitle: 'Tasks',
                            count: todayTasks.length,
                            icon: Icons.today_outlined,
                            color: const Color(0xFF1D4E89),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TaskCategoryScreen(
                                    category:
                                        TaskCategory.today,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 12),

                          _buildCategoryCard(
                            context: context,
                            title: 'Overdue',
                            subtitle: 'Tasks',
                            count: overdueTasks.length,
                            icon: Icons.warning_amber_rounded,
                            color: Colors.red,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TaskCategoryScreen(
                                    category:
                                        TaskCategory.overdue,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Upcoming
                      Row(
                        children: [
                          _buildCategoryCard(
                            context: context,
                            title: 'Upcoming',
                            subtitle: 'Tasks',
                            count: upcomingTasks.length,
                            icon: Icons.upcoming_outlined,
                            color: const Color(0xFF00897B),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TaskCategoryScreen(
                                    category:
                                        TaskCategory.upcoming,
                                  ),
                                ),
                              );
                            },
                          ),

                          const Spacer(),
                          const Spacer(),
                        ],
                      ),

                      const SizedBox(height: 90),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddTaskScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFC5CAE9),
        elevation: 2,
        icon: const Icon(
          Icons.add,
          color: Color(0xFF0D47A1),
        ),
        label: const Text(
          'Task',
          style: TextStyle(
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}