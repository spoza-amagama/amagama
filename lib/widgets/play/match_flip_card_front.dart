// 📄 lib/widgets/play/match_flip_card_front.dart
//
// Front face of a match card.

import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/theme/index.dart';

class MatchCardFront extends StatelessWidget {
  final CardItem card;
  final double scale;

  const MatchCardFront({
    super.key,
    required this.card,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final asset = 'assets/images/${card.word.toLowerCase()}.png';

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: card.isMatched
              ? [
                  AmagamaColors.success.withValues(alpha: 0.7),
                  AmagamaColors.success,
                ]
              : [
                  AmagamaColors.primary.withValues(alpha: 0.4),
                  AmagamaColors.primary,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Center(
        child: FractionallySizedBox(
          widthFactor: scale,
          heightFactor: scale,
          child: ClipOval(
            child: Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Text('🧩', style: TextStyle(fontSize: 28))),
            ),
          ),
        ),
      ),
    );
  }
}