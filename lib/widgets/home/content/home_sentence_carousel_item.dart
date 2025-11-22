// 📄 lib/widgets/home/content/home_sentence_carousel_item.dart
//
// Standalone item widget used by the home sentence carousel.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeSentenceCarouselItem extends StatelessWidget {
  final String text;
  final bool locked;
  final bool active;

  const HomeSentenceCarouselItem({
    super.key,
    required this.text,
    required this.locked,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final bg = locked
        ? AmagamaColors.textSecondary.withValues(alpha: 0.15)
        : AmagamaColors.secondary;

    return AnimatedScale(
      scale: active ? 1.0 : 0.88,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(28),
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
            if (locked)
              const Positioned(
                top: 12,
                right: 12,
                child: Icon(Icons.lock, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
