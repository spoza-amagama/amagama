// 📄 lib/widgets/grownups/pin_entry/pin_keypad_row.dart
//
// PinKeypadRow — single horizontal row of keypad buttons.

import 'package:flutter/material.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_keypad_button.dart';

class PinKeypadRow extends StatelessWidget {
  final List<String?> labels;
  final double diameter;
  final void Function(String) onTap;

  const PinKeypadRow({
    super.key,
    required this.labels,
    required this.diameter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) {
        if (label == null) {
          return const SizedBox(width: diameter, height: diameter);
        }

        return PinKeypadButton(
          label: label,
          diameter: diameter,
          onTap: () => onTap(label),
        );
      }).toList(),
    );
  }
}
