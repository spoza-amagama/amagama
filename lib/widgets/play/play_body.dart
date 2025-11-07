// 📄 lib/widgets/play/play_body.dart
import 'package:flutter/material.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/widgets/play/animated_match_grid.dart';
import 'package:amagama/services/audio/audio_service.dart';

/// 🧩 PlayBody — displays the card grid for the current round.
class PlayBody extends StatelessWidget {
  final bool fadeOut;
  final AudioService audioService;
  final GameController? game; // 👈 make optional
  final ValueChanged<String> onWord;
  final ValueChanged<String> onComplete;

  const PlayBody({
    super.key,
    required this.fadeOut,
    required this.audioService,
    this.game, // 👈 optional fallback
    required this.onWord,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final g = game; // local alias for safety
    if (g == null) {
      return const Center(child: Text('Game not initialized'));
    }

    final cards = g.deck;

    if (cards.isEmpty) {
      return const Center(
        child: Text(
          'No cards available',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    return AnimatedMatchGrid(
      sentenceId: g.currentSentenceIndex,
      cards: g.deck,
    );
  }
}
