// 📄 lib/widgets/play/match_card_back.dart
//
// 🂠 MatchCardBack — avatar ≤ 80% of card diameter
// ------------------------------------------------------------
// Circle with subtle shadow and an animal avatar constrained
// by FractionallySizedBox so it never exceeds 80%.

import 'package:flutter/material.dart';

class MatchCardBack extends StatelessWidget {
  final int id;
  final bool flashRed; // optional visual from mismatch
  const MatchCardBack({super.key, required this.id, this.flashRed = false});

  @override
  Widget build(BuildContext context) {
    final avatarIndex = (id % 30) + 1;
    final avatarFile =
        'assets/avatars/animal_${avatarIndex.toString().padLeft(2, "0")}.png';

    final baseColor = Colors.orangeAccent;
    final color = flashRed ? const Color(0xFFFF3B30) : baseColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.8,  // ✅ ≤80%
        heightFactor: 0.8, // ✅ ≤80%
        child: Image.asset(
          avatarFile,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.extension, color: Colors.green, size: 36),
        ),
      ),
    );
  }
}
