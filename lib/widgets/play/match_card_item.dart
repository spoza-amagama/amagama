// 📄 lib/widgets/play/match_card_item.dart
//
// 🎴 MatchCardItem — controller widget
// ------------------------------------------------------------
// Controls flip animation, game integration, and sparkle effects.
// Delegates visuals to external widgets:
// • [MatchCardFront] — avatar face (pre-match)
// • [MatchCardBack] — revealed word face (post-match)
//

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/services/audio/audio_service.dart';
import 'package:amagama/widgets/sparkle_layer.dart';
import 'package:amagama/utils/avatar_registry.dart';

// externalized
import 'match_card_front.dart';
import 'match_card_back.dart';

class MatchCardItem extends StatefulWidget {
  final CardItem card;
  final bool fadeOut;
  final GlobalKey<SparkleLayerState>? sparkleKey;
  final AudioService audioService;
  final ValueChanged<String> onWord;
  final ValueChanged<String> onComplete;

  const MatchCardItem({
    super.key,
    required this.card,
    required this.fadeOut,
    required this.sparkleKey,
    required this.audioService,
    required this.onWord,
    required this.onComplete,
  });

  @override
  State<MatchCardItem> createState() => _MatchCardItemState();
}

class _MatchCardItemState extends State<MatchCardItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  bool _isFront = true;
  bool _isFlipping = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  // 🧠 Game and animation orchestration
  Future<void> _handleTap() async {
    if (_isFlipping) return;
    setState(() => _isFlipping = true);

    final game = context.read<GameController>();
    final result = await game.onCardTapped(widget.card);

    // Flip animation
    await _flipController.forward();
    setState(() => _isFront = !_isFront);
    await _flipController.reverse();

    if (result == CardMatchResult.matched) {
      await widget.audioService.playWord(widget.card.word);
      widget.onWord(widget.card.word);
      widget.onComplete(widget.card.word);

      final sparkleState = widget.sparkleKey?.currentState;
      sparkleState?.triggerSparkles();
    }

    setState(() => _isFlipping = false);
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final isFading = widget.fadeOut && card.isMatched;
    final avatarAsset = AvatarRegistry.instance.avatarFor(card.id.toString());

    return AnimatedOpacity(
      opacity: isFading ? 0.25 : 1.0,
      duration: const Duration(milliseconds: 250),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _flipController,
          builder: (context, _) {
            final angle = _flipController.value * pi;
            final isFrontVisible = angle <= pi / 2;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: isFrontVisible
                  ? MatchCardFront(avatarAsset: avatarAsset)
                  : MatchCardBack(
                      word: card.word,
                      isMatched: card.isMatched,
                      sparkleKey: widget.sparkleKey,
                    ),
            );
          },
        ),
      ),
    );
  }
}