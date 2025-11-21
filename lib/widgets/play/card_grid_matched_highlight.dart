// 📄 lib/widgets/play/card_grid_matched_highlight.dart
//
// Small check badge over matched cards.

import 'package:flutter/material.dart';

class CardGridMatchedHighlight extends StatelessWidget {
  final bool visible;

  const CardGridMatchedHighlight({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade500,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}