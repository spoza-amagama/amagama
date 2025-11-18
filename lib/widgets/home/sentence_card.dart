// 📄 lib/widgets/home/sentence_card.dart
//
// 💬 SentenceCard — shows a sentence with visual state:
// • Active / completed: green
// • Locked: greyed
// • Normal: card surface
//

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
    final bool highlight = isActive || isCompleted;

    final Color activeBg = AmagamaColors.success;
    final Color activeBorder = AmagamaColors.secondary;
    final Color activeText = Colors.white;

    final Color lockedBg = AmagamaColors.overlay(0.08);
    final Color lockedBorder = AmagamaColors.overlay(0.2);
    final Color lockedText = AmagamaColors.overlay(0.55);

    final Color normalBg = AmagamaColors.surface;
    final Color normalBorder = AmagamaColors.primary;
    final Color normalText = AmagamaColors.textPrimary;

    final Color bg = isLocked
        ? lockedBg
        : highlight
            ? activeBg
            : normalBg;

    final Color border = isLocked
        ? lockedBorder
        : highlight
            ? activeBorder
            : normalBorder;

    final Color textColor = isLocked
        ? lockedText
        : highlight
            ? activeText
            : normalText;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(width: 4, color: border),
      ),
      child: Stack(
        children: [
          if (isLocked)
            const Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.lock, size: 20, color: Colors.black45),
            ),
          Center(
            child: Text(
              sentenceText,
              textAlign: TextAlign.center,
              style: AmagamaTypography.bodyStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.25,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
