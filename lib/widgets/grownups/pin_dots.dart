// 📄 lib/widgets/grownups/pin_dots.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinDots extends StatelessWidget {
  final int count; // always 4
  final int filled;

  const PinDots({
    super.key,
    this.count = 4,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isFilled = i < filled;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AmagamaColors.textPrimary : Colors.transparent,
            border: Border.all(
              color: AmagamaColors.textPrimary,
              width: 1.8,
            ),
          ),
        );
      }),
    );
  }
}