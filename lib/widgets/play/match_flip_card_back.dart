// 📄 lib/widgets/play/match_flip_card_back.dart
//
// Back face of a match card.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class MatchCardBack extends StatelessWidget {
  const MatchCardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AmagamaColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.help_outline_rounded,
          size: 38,
          color: Colors.black54,
        ),
      ),
    );
  }
}