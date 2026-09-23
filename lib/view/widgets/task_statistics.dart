import 'package:flutter/material.dart';

class TaskStatistics extends StatelessWidget {
  final int totalTasks;
  final int doneTasks;
  final int pendingTasks;

  const TaskStatistics({
    super.key,
    required this.totalTasks,
    required this.doneTasks,
    required this.pendingTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            number: totalTasks.toString(),
            label: 'Tasks',
          ),
          _StatItem(
            number: doneTasks.toString(),
            label: 'Done',
          ),
          _StatItem(
            number: pendingTasks.toString(),
            label: 'Pending',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}