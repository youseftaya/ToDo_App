import 'package:flutter/material.dart';
import '../../data/model/task_model.dart';

class StatusDropdown extends StatelessWidget {
  const StatusDropdown({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  final StatusTask selectedStatus;
  final ValueChanged<StatusTask?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<StatusTask>(
          value: selectedStatus,
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          items: const [
            DropdownMenuItem(
              value: StatusTask.pending,
              child: Text(
                'Pending',
                style: TextStyle(
                  color: Color(0xFF1E2844),
                ),
              ),
            ),
            DropdownMenuItem(
              value: StatusTask.inProgress,
              child: Text(
                'In Progress',
                style: TextStyle(
                  color: Color(0xFF1E2844),
                ),
              ),
            ),
            DropdownMenuItem(
              value: StatusTask.done,
              child: Text(
                'Done',
                style: TextStyle(
                  color: Color(0xFF1E2844),
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}