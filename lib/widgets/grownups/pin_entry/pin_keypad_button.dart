// 📄 lib/widgets/grownups/pin_entry/pin_keypad_button.dart
//
// PinKeypadButton — circular responsive button for the PIN keypad.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinKeypadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final double diameter;
  final VoidCallback onTap;

  const PinKeypadButton({
    super.key,
    this.label,
    this.icon,
    required this.diameter,
    required this.onTap,
  }) : assert(label != null || icon != null,
            'Either label or icon must be provided.');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(diameter),
      onTap: onTap,
      child: Container(
        width: diameter,
        height: diameter,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 3,
            color: AmagamaColors.textPrimary,
          ),
        ),
        child: icon != null
            ? Icon(
                icon,
                color: AmagamaColors.textPrimary,
                size: diameter * 0.42,
              )
            : Text(
                label!,
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: diameter * 0.38,
                  color: AmagamaColors.textPrimary,
                ),
              ),
      ),
    );
  }
}
