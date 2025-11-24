// 📄 lib/widgets/grownups/pin_entry/pin_keypad.dart
//
// PinKeypad — shared numeric keypad for PIN entry.
// ------------------------------------------------------------
// • 3×3 digits + 0 + backspace
// • Emits String digits ("0"-"9")
// • Emits onBackspace() when backspace is tapped
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
            _row(size, ["1", "2", "3"]),
            _row(size, ["4", "5", "6"]),
            _row(size, ["7", "8", "9"]),
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
            .map((d) => PinKeypadButton(
                  label: d,
                  size: size,
                  onTap: () => onDigit(d),
                ))
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
          SizedBox(width: size), // empty spacer
          PinKeypadButton(
            label: "0",
            size: size,
            onTap: () => onDigit("0"),
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