// 📄 lib/widgets/home/home_progress_bar.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeProgressBar extends StatelessWidget {
  final int progress;
  final int target;

  const HomeProgressBar({
    super.key,
    required this.progress,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: AmagamaColors.overlay(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FractionallySizedBox(
        widthFactor: (progress / target).clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AmagamaColors.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}