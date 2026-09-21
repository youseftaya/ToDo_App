import 'dart:developer';

import 'package:flutter/material.dart';

import '../../data/model/task_model.dart';
import '../widgets/custom_material.dart';
import '../widgets/status_dropdown.dart';
import '../widgets/choose_color_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();

  StatusTask _selectedStatus = StatusTask.pending;

  int? colorSelected;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
              controller: _titleController,
              hintText: 'Design Login Screen',
            ),
            const SizedBox(height: 20),
            _buildFieldLabel('Description'),
            const SizedBox(height: 8),
            CustomMaterial(
              controller: _descriptionController,
              hintText: 'Task Description...',
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            _buildFieldLabel('Status'),
            const SizedBox(height: 8),
            StatusDropdown(
              selectedStatus: _selectedStatus,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatus = newValue;
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
                onPressed: () {
                  log("Title: ${_titleController.text}");
                  log("Des: ${_descriptionController.text}");
                  log("Status: $_selectedStatus");
                  log("Color: $colorSelected");
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