// 📄 sentence_carousel_item.dart
// Displays a single sentence card (green/grey) with optional lock icon.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SentenceCarouselItem extends StatelessWidget {
  final String text;
  final bool isUnlocked;
  final bool isActive;

  const SentenceCarouselItem({
    super.key,
    required this.text,
    required this.isUnlocked,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isUnlocked
        ? AmagamaColors.secondary
        : AmagamaColors.textSecondary.withValues(alpha: 0.15);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AmagamaSpacing.radiusLg),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AmagamaTypography.titleStyle.copyWith(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
          if (!isUnlocked)
            const Positioned(
              right: 12,
              top: 12,
              child: Icon(Icons.lock, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }
}
