// 📄 lib/widgets/grownups/keypad.dart

import 'package:flutter/material.dart';
import 'keypad_button.dart';

class GrownupsKeypad extends StatelessWidget {
  final void Function(String digit) onDigit;
  final VoidCallback onBackspace;

  const GrownupsKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
  });

  Widget _row(List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: values.map((v) {
        if (v.isEmpty) return const SizedBox(width: 70);

        if (v == "⌫") {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: KeypadButton(
              label: v,
              onPressed: onBackspace,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: KeypadButton(
            label: v,
            onPressed: () => onDigit(v),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(["1", "2", "3"]),
        const SizedBox(height: 14),
        _row(["4", "5", "6"]),
        const SizedBox(height: 14),
        _row(["7", "8", "9"]),
        const SizedBox(height: 14),
        _row(["", "0", "⌫"]),
      ],
    );
  }
}