// 📄 lib/widgets/grownups/keypad_button.dart
import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const KeypadButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AmagamaColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.brown.shade300),
        ),
        child: Text(
          label,
          style: AmagamaTypography.titleStyle.copyWith(fontSize: 26),
        ),
      ),
    );
  }
}