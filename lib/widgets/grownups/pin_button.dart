// 📄 lib/widgets/grownups/pin_button.dart
//
// 🔢 PinButton — circular numeric button used in the PIN keypad.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinButton extends StatelessWidget {
  final int number;
  final double size;
  final VoidCallback onTap;

  const PinButton({
    super.key,
    required this.number,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(size),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 3,
            color: AmagamaColors.textPrimary,
          ),
        ),
        child: Text(
          number.toString(),
          style: AmagamaTypography.titleStyle.copyWith(
            fontSize: 28,
            color: AmagamaColors.textPrimary,
          ),
        ),
      ),
    );
  }
}