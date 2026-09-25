import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage(
                'assets/image/profile.jpg.jpeg',
              ),
            ),

            Positioned(
              right: 0,
              bottom: 2,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1D5C9B),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        const Text(
          'Create Your Profile',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Add Your name and profile picture',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}