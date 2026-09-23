import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:untitled/core/app_routes.dart';
import 'package:untitled/data/model/task_model.dart';
import 'package:untitled/data/model/user_model.dart';
import 'package:untitled/view/screens/add_task_screen.dart';
import 'package:untitled/view/screens/home_screen.dart';
import 'package:untitled/view/screens/profile_screens.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(StatusTaskAdapter());

  await Hive.openBox<UserModel>('User');
  await Hive.openBox<TaskModel>('Tasks');

  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.addTask: (context) => const AddTaskScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}