// 📄 lib/widgets/home/sentence_card.dart
//
// 🃏 SentenceCard — week-free, cycle-free sentence card used in the home carousel.
// State logic:
// • isLocked     → dimmed + disabled styling
// • isCompleted  → optional check badge
// • isActive     → highlighted border
//
// No week logic, no cycle UI.

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
    final Color baseColor = isLocked
        ? AmagamaColors.surface.withAlpha(180)    // 70% strength
        : AmagamaColors.surface;

    final Color borderColor = isActive
        ? AmagamaColors.primary
        : AmagamaColors.textSecondary.withAlpha(90);

    final Color shadowColor =
        AmagamaColors.textPrimary.withAlpha(32); // ~12% shadow

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
          width: isActive ? 2.4 : 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ---------------------------
          // Sentence text
          // ---------------------------
          Opacity(
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

          // ---------------------------
          // Completed badge (top-right)
          // ---------------------------
          if (isCompleted && !isLocked)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.check_circle,
                size: 20,
                color: AmagamaColors.success,
              ),
            ),
        ],
      ),
    );
  }
}