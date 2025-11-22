// 📄 lib/widgets/grownups/pin_entry/pin_keypad.dart
//
// PinKeypad — responsive numeric keypad for PIN entry.
// • Auto-scales button size from screen dimensions
// • 3×3 grid + bottom row (0 + backspace)
// • Works in portrait & landscape

import 'package:flutter/material.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_keypad_button.dart';

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
    final size = MediaQuery.of(context).size;

    // Button diameter based on shortest side; clamped for phones/tablets
    final double diameter =
        (size.shortestSide * 0.16).clamp(44.0, 80.0); // 44–80 px
    final double vGap = diameter * 0.35;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(['1', '2', '3'], diameter),
        const SizedBox(height: vGap),
        _row(['4', '5', '6'], diameter),
        const SizedBox(height: vGap),
        _row(['7', '8', '9'], diameter),
        const SizedBox(height: vGap),
        _bottomRow(diameter),
      ],
    );
  }

  Widget _row(List<String> labels, double diameter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels
          .map(
            (label) => PinKeypadButton(
              label: label,
              diameter: diameter,
              onTap: () => onDigit(label),
            ),
          )
          .toList(),
    );
  }

  Widget _bottomRow(double diameter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: diameter, height: diameter),
        PinKeypadButton(
          label: '0',
          diameter: diameter,
          onTap: () => onDigit('0'),
        ),
        PinKeypadButton(
          icon: Icons.backspace_rounded,
          diameter: diameter,
          onTap: onBackspace,
        ),
      ],
    );
  }
}
