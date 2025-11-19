// 📄 lib/widgets/play/card_grid_glow.dart
//
// Subtle glow effect rendered behind an active card.

import 'package:flutter/material.dart';

class CardGridGlow extends StatelessWidget {
  final bool active;

  const CardGridGlow({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    if (!active) return const SizedBox.shrink();

    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.35),
              blurRadius: 22,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}