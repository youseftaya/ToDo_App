import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onPickImage;

  const ProfileHeader({
    super.key,
    this.imageBytes,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage: imageBytes != null
                  ? MemoryImage(imageBytes!)
                  : const AssetImage(
                      'assets/image/profile.jpg.jpeg',
                    ) as ImageProvider,
            ),

            Positioned(
              right: -2,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPickImage,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1D5C9B),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
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