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
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.brown.shade200),
        ),
        child: Text(
          label,
          style: AmagamaTypography.sectionTitleStyle.copyWith(
            fontSize: 24,
            color: AmagamaColors.textPrimary,
          ),
        ),
      ),
    );
  }
}