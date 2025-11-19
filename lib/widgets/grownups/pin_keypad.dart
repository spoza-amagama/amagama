// 📄 lib/widgets/grownups/pin_keypad.dart
//
// 🔢 PinKeypad — 3×4 numeric keypad for PIN entry.

import 'package:flutter/material.dart';
import 'pin_keypad_row.dart';

class PinKeypad extends StatelessWidget {
  final void Function(int) onTap;

  const PinKeypad({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final size = constraints.maxWidth / 3 - 16;

        return Column(
          children: [
            PinKeypadRow(
              numbers: const [1, 2, 3],
              size: size,
              onTap: onTap,
            ),
            PinKeypadRow(
              numbers: const [4, 5, 6],
              size: size,
              onTap: onTap,
            ),
            PinKeypadRow(
              numbers: const [7, 8, 9],
              size: size,
              onTap: onTap,
            ),
            PinKeypadRow(
              numbers: const [null, 0, null],
              size: size,
              onTap: onTap,
            ),
          ],
        );
      },
    );
  }
}