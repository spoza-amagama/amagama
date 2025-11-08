// 📄 lib/widgets/play/match_card_front.dart
//
// 🂡 MatchCardFront
// ------------------------------------------------------------
// Displays the front of the card (word text).
// Turns green if matched.

import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';

class MatchCardFront extends StatelessWidget {
  final CardItem card;

  const MatchCardFront({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final color = card.isMatched ? Colors.lightGreen : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            card.word,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
