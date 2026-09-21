import 'package:flutter/material.dart';
import 'package:untitled/core/app_routes.dart';
import 'package:untitled/view/screens/add_task_screen.dart';
import 'package:untitled/view/screens/home_screen.dart';
import 'package:untitled/view/screens/profile_screens.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.profile,
      routes: {
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.addTask: (context) => const AddTaskScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}