// 📄 lib/widgets/grownups/pin_entry/pin_dots.dart
//
// PinDots — 4-dot indicator for entered PIN length.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinDots extends StatelessWidget {
  final int filled; // 0–4

  const PinDots({super.key, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final bool active = i < filled;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AmagamaColors.textPrimary,
              width: 2,
            ),
            color: active ? AmagamaColors.textPrimary : Colors.transparent,
          ),
        );
      }),
    );
  }
}
