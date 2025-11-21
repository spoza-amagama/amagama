// 📄 lib/widgets/home/home_progress_bar.dart
//
// 📈 HomeProgressBar — per-sentence cycles progress.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeProgressBar extends StatelessWidget {
  final int cyclesDone;
  final int cyclesTarget;

  const HomeProgressBar({
    super.key,
    required this.cyclesDone,
    required this.cyclesTarget,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = cyclesTarget == 0
        ? 0.0
        : (cyclesDone / cyclesTarget).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: fraction,
        minHeight: 10,
        backgroundColor:
            AmagamaColors.surface.withValues(alpha: 0.6),
        color: AmagamaColors.secondary,
      ),
    );
  }
}