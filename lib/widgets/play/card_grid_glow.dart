// 📄 lib/widgets/play/card_grid_glow.dart
//
// 💡 CardGridGlow
// ------------------------------------------------------------
// Animated glow overlay displayed on recently flipped cards.
//
// RESPONSIBILITIES
// • Fades in/out around a card when flipped.
// • Driven by [CardGridController.isGlowing].
//
// DEPENDENCIES
// • [CardGridController] — state source for glow animation.
//

import 'package:flutter/material.dart';

class CardGridGlow extends StatelessWidget {
  final bool active;
  final double radius;

  const CardGridGlow({
    super.key,
    required this.active,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: active ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.yellowAccent.withValues(alpha: 0.6),
              blurRadius: radius / 2,
              spreadRadius: radius / 6,
            ),
          ],
        ),
      ),
    );
  }
}
