// 📄 lib/widgets/home/sentences/sentence_card.dart
//
// 🃏 SentenceCard — clean locked/unlocked behaviour.

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
        ? AmagamaColors.surface.withAlpha(180)
        : AmagamaColors.surface;

    final Color borderColor = isActive
        ? AmagamaColors.primary
        : AmagamaColors.textSecondary.withAlpha(90);

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
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main sentence text
          Opacity(
            opacity: isLocked ? 0.4 : 1.0,
            child: Text(
              sentenceText,
              style: AmagamaTypography.bodyStyle.copyWith(
                fontSize: 18,
                color: AmagamaColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // SIMPLE LOCK ICON (no blur, no tint)
          if (isLocked)
            const Icon(
              Icons.lock_rounded,
              size: 48,
              color: Color(0x55000000), // soft watermark
            ),

          // Completed checkmark (unlocked only)
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