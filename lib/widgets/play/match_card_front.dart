// 📄 lib/widgets/play/match_card_front.dart
//
// 🟣 MatchCardFront
// ------------------------------------------------------------
// Displays the front (avatar) side of a memory card before match.
//
import 'package:flutter/material.dart';

class MatchCardFront extends StatelessWidget {
  final String avatarAsset;
  const MatchCardFront({super.key, required this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = constraints.biggest.shortestSide;
        final avatarSize = diameter * 0.8;

        return Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              avatarAsset,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
