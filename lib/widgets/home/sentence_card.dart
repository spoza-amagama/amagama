// 📄 lib/widgets/home/sentence_card.dart
//
// 🃏 SentenceCard — card used in the home sentence carousel.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SentenceCard extends StatelessWidget {
  final String sentenceText;
  final bool isActive;
  final bool isCompleted;
  final bool isLocked;

  const SentenceCard({
    super.key,
    required this.sentenceText,
    required this.isActive,
    required this.isCompleted,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isLocked
        ? AmagamaColors.surface.withValues(alpha: 0.7)
        : AmagamaColors.surface;

    final borderColor = isActive
        ? AmagamaColors.primary
        : AmagamaColors.textSecondary.withValues(alpha: 0.3);

    final shadowColor =
        AmagamaColors.textPrimary.withValues(alpha: 0.12);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
          width: isActive ? 2.4 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Opacity(
        opacity: isLocked ? 0.55 : 1.0,
        child: Text(
          sentenceText,
          style: AmagamaTypography.bodyStyle.copyWith(
            fontSize: 18,
            color: AmagamaColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}