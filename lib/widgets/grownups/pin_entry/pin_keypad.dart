// 📄 lib/widgets/grownups/pin_entry/pin_keypad.dart
//
// PinKeypad — 3×4 numeric keypad for PIN entry.
// ------------------------------------------------------------
// • Digits 0–9 as circular buttons
// • Emits String digits via onDigit
// • Backspace button via onBackspace
//

import 'package:flutter/material.dart';
import 'pin_keypad_button.dart';

class PinKeypad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onBackspace;

  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final size = constraints.maxWidth / 3 - 16;

        return Column(
          children: [
            _row(size, const ["1", "2", "3"]),
            _row(size, const ["4", "5", "6"]),
            _row(size, const ["7", "8", "9"]),
            _bottomRow(size),
          ],
        );
      },
    );
  }

  Widget _row(double size, List<String> digits) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: digits
            .map(
              (d) => PinKeypadButton(
                label: d,
                size: size,
                onTap: () => onDigit(d),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _bottomRow(double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: size), // spacer
          PinKeypadButton(
            label: '0',
            size: size,
            onTap: () => onDigit('0'),
          ),
          PinKeypadButton(
            icon: Icons.backspace_rounded,
            size: size,
            onTap: onBackspace,
          ),
        ],
      ),
    );
  }
}