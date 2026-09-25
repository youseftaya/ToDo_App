import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/data/model/task_model.dart';
import 'package:untitled/view/screens/add_task_screen.dart';
import '../widgets/home_header.dart';
import '../widgets/task_statistics.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<TaskModel> taskBox = Hive.box<TaskModel>('Tasks');

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: taskBox.listenable(),
          builder: (context, Box<TaskModel> box, _) {
            final tasks = box.values.toList();

            final doneTasks = tasks
                .where((task) => task.status == StatusTask.done)
                .length;

            final pendingTasks = tasks
                .where((task) => task.status == StatusTask.pending)
                .length;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),

                  const SizedBox(height: 24),

                  TaskStatistics(
                    totalTasks: tasks.length,
                    doneTasks: doneTasks,
                    pendingTasks: pendingTasks,
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (tasks.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          'No tasks yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    ...tasks.map(
                      (task) => TaskCard(
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
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
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