import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

class HomeHeader extends StatelessWidget {
  final Uint8List? imageBytes;

  const HomeHeader({
    super.key,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.profile,
                  );
                },
              ),
            ),

            const SizedBox(width: 8),

            CircleAvatar(
              radius: 24,
              backgroundImage: imageBytes != null
                  ? MemoryImage(imageBytes!)
                  : const AssetImage(
                      'assets/image/profile.jpg.jpeg',
                    ) as ImageProvider,
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning 👋',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'Yousef Mahmoud',
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
    );
  }
}