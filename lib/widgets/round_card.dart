// 📄 lib/widgets/play/match_card_item.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/services/audio/audio_service.dart';
import 'package:amagama/widgets/sparkle_layer.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:provider/provider.dart';
import 'package:amagama/utils/avatar_registry.dart';

/// 🎴 MatchCardItem — round flip-card with avatar and word reveal animation.
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
  late AnimationController _flipController;
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

  Future<void> _handleTap() async {
    if (_isFlipping) return;
    setState(() => _isFlipping = true);

    final game = context.read<GameController>();
    final result = await game.onCardTapped(widget.card);

    // Start flip animation
    await _flipController.forward();
    setState(() => _isFront = !_isFront);
    await _flipController.reverse();

    if (result == CardMatchResult.matched) {
      // ✅ Safe sequence: audio + sparkle + callbacks
      await widget.audioService.playWord(widget.card.word);
      widget.onWord(widget.card.word);
      widget.onComplete(widget.card.word);

      // ✅ Safe null-checked sparkle trigger
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
          builder: (context, child) {
            final angle = _flipController.value * pi;
            final isFrontVisible = angle <= pi / 2;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: isFrontVisible
                  ? _buildFront(avatarAsset)
                  : _buildBack(card.word, card.isMatched),
            );
          },
        ),
      ),
    );
  }

  /// 🟣 Back of card — shows avatar (unmatched state)
  Widget _buildFront(String avatarAsset) {
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
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

  /// 🟢 Front of card — revealed word
  Widget _buildBack(String word, bool isMatched) {
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
                boxShadow: [
                  BoxShadow(
                    color: isMatched
                        ? Colors.green.shade700.withValues(alpha: 0.3)
                        : Colors.red.shade700.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isMatched
                      ? Colors.green.shade700
                      : Colors.red.shade400,
                  width: 2,
                ),
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
            if (isMatched && widget.sparkleKey != null)
              SparkleLayer(key: widget.sparkleKey!),
          ],
        );
      },
    );
  }
}