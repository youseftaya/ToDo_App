import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF0D47A1),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Good Morning 👋',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Ahmed',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black87,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      number: '12',
                      label: 'Tasks',
                    ),
                    _StatItem(
                      number: '5',
                      label: 'Done',
                    ),
                    _StatItem(
                      number: '7',
                      label: 'Pending',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                "Today's Tasks",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              const TaskCard(
                title: 'Flutter UI',
                subtitle: 'Build Register Screen',
                status: 'Pending',
                indicatorColor: Colors.blue,
                statusBgColor: Color(0xFFE3F2FD),
                statusTextColor: Colors.blue,
              ),

              const TaskCard(
                title: 'Workout',
                subtitle: 'Gym at 6 PM',
                status: 'Done',
                indicatorColor: Colors.green,
                statusBgColor: Color(0xFFE8F5E9),
                statusTextColor: Colors.green,
              ),

              const TaskCard(
                title: 'Meeting',
                subtitle: 'Team Sync',
                status: 'In Progress',
                indicatorColor: Colors.orange,
                statusBgColor: Color(0xFFFFF3E0),
                statusTextColor: Colors.orange,
              ),

              const TaskCard(
                title: 'Read Book',
                subtitle: 'Atomic Habits',
                status: 'Pending',
                indicatorColor: Colors.purple,
                statusBgColor: Color(0xFFF3E5F5),
                statusTextColor: Colors.purple,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFFC5CAE9),
        elevation: 2,
        icon: const Icon(
          Icons.add,
          color: Color(0xFF0D47A1),
        ),
        label: const Text(
          'Task',
          style: TextStyle(
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.bold,
          ),
        ),
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

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color indicatorColor;
  final Color statusBgColor;
  final Color statusTextColor;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.indicatorColor,
    required this.statusBgColor,
    required this.statusTextColor,
  });

  @override
  Widget build(BuildContext context) {
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
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
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
                    status,
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

          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
            size: 18,
          ),
        ],
      ),
    );
  }
}