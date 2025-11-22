// 📄 pin_title.dart
import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinTitle extends StatelessWidget {
  final String text;

  const PinTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AmagamaTypography.titleStyle.copyWith(
        fontSize: 26,
        color: AmagamaColors.textPrimary,
      ),
    );
  }
}
