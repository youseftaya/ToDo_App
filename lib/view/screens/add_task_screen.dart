import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../data/model/task_model.dart';
import '../widgets/custom_material.dart';
import '../widgets/status_dropdown.dart';
import '../widgets/choose_color_widget.dart';
import '../../core/app_dialog.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleTask = TextEditingController();
  final TextEditingController desTask = TextEditingController();

  StatusTask selectedStatus = StatusTask.pending;

  int? colorSelected;

  DateTime? dueDate;
  DateTime? reminder;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleTask.text = widget.task!.title;
      desTask.text = widget.task!.description;
      selectedStatus = widget.task!.status;
      colorSelected = widget.task!.colorHex;

      dueDate = widget.task!.dueDate;
      reminder = widget.task!.reminder;
    }
  }

  @override
  void dispose() {
    titleTask.dispose();
    desTask.dispose();
    super.dispose();
  }

  // Select Due Date
  Future<void> _selectDueDate() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dueDate = pickedDate;
      });
    }
  }

  // Select Reminder Date & Time
  Future<void> _selectReminder() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: reminder ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: reminder != null
          ? TimeOfDay.fromDateTime(reminder!)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return;
    }

    setState(() {
      reminder = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatReminder(DateTime date) {
    final String day = '${date.day}/${date.month}/${date.year}';

    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');

    return '$day - $hour:$minute';
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
        title: Text(
          isEditing ? 'Edit Task' : 'Add Task',
          style: const TextStyle(
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

            // Due Date
            _buildFieldLabel('Due Date'),
            const SizedBox(height: 8),
            _buildDateContainer(
              icon: Icons.calendar_today_outlined,
              text: dueDate == null
                  ? 'Select Due Date'
                  : _formatDate(dueDate!),
              isSelected: dueDate != null,
              onTap: _selectDueDate,
            ),

            const SizedBox(height: 20),

            // Reminder
            _buildFieldLabel('Reminder'),
            const SizedBox(height: 8),
            _buildDateContainer(
              icon: Icons.notifications_none_outlined,
              text: reminder == null
                  ? 'Set Reminder'
                  : _formatReminder(reminder!),
              isSelected: reminder != null,
              onTap: _selectReminder,
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
                  log("Due Date: $dueDate");
                  log("Reminder: $reminder");

                  if (colorSelected == null) {
                    showError(
                      context,
                      'Please choose a color',
                    );
                    return;
                  }

                  showLoading(context);

                  try {
                    if (isEditing) {
                      widget.task!.title = titleTask.text;
                      widget.task!.description = desTask.text;
                      widget.task!.status = selectedStatus;
                      widget.task!.colorHex = colorSelected!;
                      widget.task!.dueDate = dueDate;
                      widget.task!.reminder = reminder;

                      await widget.task!.save();
                    } else {
                      final taskBox = Hive.box<TaskModel>('Tasks');

                      await taskBox.add(
                        TaskModel(
                          title: titleTask.text,
                          description: desTask.text,
                          status: selectedStatus,
                          colorHex: colorSelected!,
                          dueDate: dueDate,
                          reminder: reminder,
                        ),
                      );
                    }

                    if (context.mounted) {
                      // Close Loading Dialog
                      Navigator.of(context).pop();

                      // Return to Home Screen
                      Navigator.of(context).pop();
                    }
                  } catch (error) {
                    if (context.mounted) {
                      // Close Loading Dialog
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
                child: Text(
                  isEditing ? 'Update Task' : 'Save Task',
                  style: const TextStyle(
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

  Widget _buildDateContainer({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF64748B),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF94A3B8),
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