import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../data/model/task_model.dart';
import '../widgets/custom_material.dart';
import '../widgets/status_dropdown.dart';
import '../widgets/choose_color_widget.dart';
import '../../core/app_dialog.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleTask = TextEditingController();
  final TextEditingController desTask = TextEditingController();

  StatusTask selectedStatus = StatusTask.pending;

  int? colorSelected;

  @override
  void dispose() {
    titleTask.dispose();
    desTask.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1E2844),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Task',
          style: TextStyle(
            color: Color(0xFF1E2844),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('Task Title'),
            const SizedBox(height: 8),
            CustomMaterial(
              controller: titleTask,
              hintText: 'Design Login Screen',
            ),
            const SizedBox(height: 20),

            _buildFieldLabel('Description'),
            const SizedBox(height: 8),
            CustomMaterial(
              controller: desTask,
              hintText: 'Task Description...',
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            _buildFieldLabel('Status'),
            const SizedBox(height: 8),
            StatusDropdown(
              selectedStatus: selectedStatus,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            _buildFieldLabel('Choose Color'),
            const SizedBox(height: 12),
            ChooseColorWidget(
              selectedColor: colorSelected,
              clickColor: (color) {
                log(color.toString());

                setState(() {
                  colorSelected = color;
                });
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  log("Title: ${titleTask.text}");
                  log("Des: ${desTask.text}");
                  log("Status: $selectedStatus");
                  log("Color: $colorSelected");

                  if (colorSelected == null) {
                    showError(
                      context,
                      'Please choose a color',
                    );
                    return;
                  }

                  showLoading(context);

                  try {
                    final taskBox = Hive.box<TaskModel>('Tasks');

                    await taskBox.add(
                      TaskModel(
                        title: titleTask.text,
                        description: desTask.text,
                        status: selectedStatus,
                        colorHex: colorSelected!,
                      ),
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  } catch (error) {
                    if (context.mounted) {
                      Navigator.of(context).pop();

                      showError(
                        context,
                        error.toString(),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4E89),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Task',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E2844),
      ),
    );
  }
}