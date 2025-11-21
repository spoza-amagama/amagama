// 📄 lib/widgets/grownups/pin_keypad_row.dart
//
// 🔢 PinKeypadRow — a single horizontal row of three PIN buttons.

import 'package:flutter/material.dart';
import 'pin_button.dart';

class PinKeypadRow extends StatelessWidget {
  final List<int?> numbers;
  final double size;
  final void Function(int) onTap;

  const PinKeypadRow({
    super.key,
    required this.numbers,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: numbers.map((n) {
          // Empty placeholder space in keypad layout
          if (n == null) {
            return SizedBox(width: size, height: size);
          }

          return PinButton(
            number: n,
            size: size,
            onTap: () => onTap(n),
          );
        }).toList(),
      ),
    );
  }
}