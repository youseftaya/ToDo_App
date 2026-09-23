import 'package:flutter/material.dart';
import 'package:untitled/data/model/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = Color(task.colorHex);

    String statusText;
    Color statusBgColor;
    Color statusTextColor;

    switch (task.status) {
      case StatusTask.pending:
        statusText = 'Pending';
        statusBgColor = const Color(0xFFE3F2FD);
        statusTextColor = Colors.blue;
        break;

      case StatusTask.done:
        statusText = 'Done';
        statusBgColor = const Color(0xFFE8F5E9);
        statusTextColor = Colors.green;
        break;

      case StatusTask.inProgress:
        statusText = 'In Progress';
        statusBgColor = const Color(0xFFFFF3E0);
        statusTextColor = Colors.orange;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 50,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () async {
              await task.delete();
            },
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}