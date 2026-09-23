import 'package:flutter/material.dart';

class ChooseColorWidget extends StatelessWidget {
  const ChooseColorWidget({
    super.key,
    required this.clickColor,
    required this.selectedColor,
  });

  final ValueChanged<int> clickColor;
  final int? selectedColor;

  final List<int> colors = const [
    0xFF2196F3,
    0xFF4CAF50,
    0xFFFF9800,
    0xFF673AB7,
    0xFFE53935,
    0xFF009688,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: colors.map((color) {
        final bool isSelected = selectedColor == color;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              clickColor(color);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(color),
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: Colors.black,
                        width: 2,
                      )
                    : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}