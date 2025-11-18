// 📄 lib/widgets/play/match_card_back.dart
//
// 🟢 MatchCardBack
// ------------------------------------------------------------
// Displays the back side of a memory card — the revealed word.
// Includes optional sparkles when matched.
//
import 'package:flutter/material.dart';
import 'package:amagama/widgets/sparkle_layer.dart';

class MatchCardBack extends StatelessWidget {
  final String word;
  final bool isMatched;
  final GlobalKey<SparkleLayerState>? sparkleKey;

  const MatchCardBack({
    super.key,
    required this.word,
    required this.isMatched,
    this.sparkleKey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = constraints.biggest.shortestSide;
        final bgColor = isMatched ? Colors.green.shade100 : Colors.red.shade100;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                border: Border.all(
                  color:
                      isMatched ? Colors.green.shade700 : Colors.red.shade400,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isMatched
                        ? Colors.green.shade700.withValues(alpha: 0.3)
                        : Colors.red.shade700.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                word,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isMatched
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ),
            if (isMatched && sparkleKey != null)
              SparkleLayer(key: sparkleKey!),
          ],
        );
      },
    );
  }
}