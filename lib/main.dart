import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:untitled/core/app_routes.dart';
import 'package:untitled/core/app_theme.dart';
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
  await Hive.openBox('Settings');

  final settingsBox = Hive.box('Settings');

  final isDarkMode = settingsBox.get(
    'darkMode',
    defaultValue: false,
  );

  AppThemeController.setDarkMode(isDarkMode);

  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.profile,
          themeMode: themeMode,

          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF7F9FC),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1D4E89),
              brightness: Brightness.light,
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1D4E89),
              brightness: Brightness.dark,
            ),
          ),

          routes: {
            AppRoutes.profile: (context) => const ProfileScreen(),
            AppRoutes.addTask: (context) => const AddTaskScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}