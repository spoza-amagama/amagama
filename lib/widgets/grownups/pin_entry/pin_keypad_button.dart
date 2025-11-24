import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinKeypadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final double size;
  final VoidCallback onTap;

  const PinKeypadButton({
    super.key,
    this.label,
    this.icon,
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
        child: icon != null
            ? Icon(
                icon,
                color: AmagamaColors.textPrimary,
                size: size * 0.45,
              )
            : Text(
                label!,
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: size * 0.38,
                  color: AmagamaColors.textPrimary,
                ),
              ),
      ),
    );
  }
}