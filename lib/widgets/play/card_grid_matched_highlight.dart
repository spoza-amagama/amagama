// 📄 lib/widgets/play/card_grid_matched_highlight.dart
//
// ✅ CardGridMatchedHighlight
// ------------------------------------------------------------
// Animated success overlay for matched card pairs.
//
// RESPONSIBILITIES
// • Scales up with a green accent when two cards match.
// • Driven by [CardGridController.isMatched].
//
// DEPENDENCIES
// • [CardGridController] — source for match state.
//

import 'package:flutter/material.dart';

class CardGridMatchedHighlight extends StatelessWidget {
  final bool visible;

  const CardGridMatchedHighlight({
    super.key,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.greenAccent.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}