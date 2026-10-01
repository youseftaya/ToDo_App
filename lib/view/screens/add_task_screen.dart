import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core/app_dialog.dart';
import '../../core/notification_service.dart';
import '../../data/model/task_model.dart';
import '../widgets/choose_color_widget.dart';
import '../widgets/custom_material.dart';
import '../widgets/status_dropdown.dart';

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

  Future<void> _selectReminder() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: reminder ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) {
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

  int _getNotificationId(dynamic key) {
    return key.hashCode & 0x7fffffff;
  }

  Future<void> _saveTask() async {
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
      int notificationId;

      if (isEditing) {
        final task = widget.task!;

        notificationId = _getNotificationId(task.key);

        // إلغاء الإشعار القديم قبل تحديث الـ Task
        await NotificationService.cancelNotification(
          notificationId,
        );

        task.title = titleTask.text;
        task.description = desTask.text;
        task.status = selectedStatus;
        task.colorHex = colorSelected!;
        task.dueDate = dueDate;
        task.reminder = reminder;

        await task.save();
      } else {
        final taskBox = Hive.box<TaskModel>('Tasks');

        final taskKey = await taskBox.add(
          TaskModel(
            title: titleTask.text,
            description: desTask.text,
            status: selectedStatus,
            colorHex: colorSelected!,
            dueDate: dueDate,
            reminder: reminder,
          ),
        );

        notificationId = _getNotificationId(taskKey);
      }

      // لو فيه Reminder جديد، نحجز الإشعار
      if (reminder != null) {
        await NotificationService.scheduleNotification(
          id: notificationId,
          title: titleTask.text.isEmpty
              ? 'Task Reminder'
              : titleTask.text,
          body: desTask.text.isEmpty
              ? 'You have a task reminder.'
              : desTask.text,
          dateTime: reminder!,
        );
      }

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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;

    final textColor = colorScheme.onSurface;

    final secondaryTextColor = isDark
        ? Colors.grey.shade400
        : const Color(0xFF64748B);

    final borderColor = isDark
        ? Colors.grey.shade700
        : const Color(0xFFE2E8F0);

    final containerColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          isEditing ? 'Edit Task' : 'Add Task',
          style: TextStyle(
            color: textColor,
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
            _buildFieldLabel(
              'Task Title',
              textColor,
            ),

            const SizedBox(height: 8),

            CustomMaterial(
              controller: titleTask,
              hintText: 'Design Login Screen',
            ),

            const SizedBox(height: 20),

            _buildFieldLabel(
              'Description',
              textColor,
            ),

            const SizedBox(height: 8),

            CustomMaterial(
              controller: desTask,
              hintText: 'Task Description...',
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            _buildFieldLabel(
              'Status',
              textColor,
            ),

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

            _buildFieldLabel(
              'Due Date',
              textColor,
            ),

            const SizedBox(height: 8),

            _buildDateContainer(
              icon: Icons.calendar_today_outlined,
              text: dueDate == null
                  ? 'Select Due Date'
                  : _formatDate(dueDate!),
              isSelected: dueDate != null,
              onTap: _selectDueDate,
              containerColor: containerColor,
              borderColor: borderColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),

            const SizedBox(height: 20),

            _buildFieldLabel(
              'Reminder',
              textColor,
            ),

            const SizedBox(height: 8),

            _buildDateContainer(
              icon: Icons.notifications_none_outlined,
              text: reminder == null
                  ? 'Set Reminder'
                  : _formatReminder(reminder!),
              isSelected: reminder != null,
              onTap: _selectReminder,
              containerColor: containerColor,
              borderColor: borderColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),

            const SizedBox(height: 20),

            _buildFieldLabel(
              'Choose Color',
              textColor,
            ),

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
                onPressed: _saveTask,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF1D4E89),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(26),
                  ),

                  elevation: 0,
                ),

                child: Text(
                  isEditing
                      ? 'Update Task'
                      : 'Save Task',

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
    required Color containerColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
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
          color: containerColor,

          borderRadius:
              BorderRadius.circular(14),

          border: Border.all(
            color: borderColor,
          ),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: secondaryTextColor,
            ),

            const SizedBox(width: 12),

            Text(
              text,

              style: TextStyle(
                fontSize: 15,

                color: isSelected
                    ? textColor
                    : (Theme.of(context).brightness ==
                            Brightness.dark
                        ? Colors.grey.shade500
                        : const Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(
    String title,
    Color textColor,
  ) {
    return Text(
      title,

      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}