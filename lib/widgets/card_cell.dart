// 📄 lib/widgets/card_cell.dart
//
// 💡 CardCell
// ----------------------
// Purely visual wrapper that displays one [RoundCard] inside
// an animated glow or match highlight. This widget does not
// contain game or audio logic — it only responds to visual state
// updates from the [CardGridController].

import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/widgets/round_card.dart';

class CardCell extends StatelessWidget {
  final CardItem item;
  final bool isMatched;
  final bool isGlowing;
  final double size;
  final bool lockInput;
  final Future<void> Function() onFlip;

  const CardCell({
    super.key,
    required this.item,
    required this.isMatched,
    required this.isGlowing,
    required this.size,
    required this.onFlip,
    this.lockInput = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> shadows = [
      if (isMatched)
        BoxShadow(
          color: Colors.green.withValues(alpha: 0.6),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      if (isGlowing)
        BoxShadow(
          color: Colors.amber.withValues(alpha: 0.6),
          blurRadius: 10,
          spreadRadius: 1,
        ),
    ];

    return AnimatedScale(
      scale: isMatched ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(boxShadow: shadows),
        child: Center(
          child: RoundCard(
            item: item,
            lockInput: lockInput,
            onFlip: onFlip,
            size: size,
            avatarScale: 0.8,
          ),
        ),
      ),
    );
  }
}