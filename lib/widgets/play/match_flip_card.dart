// 📄 lib/widgets/play/match_flip_card.dart
//
// 🎴 MatchFlipCard
// ------------------------------------------------------------
// Visual component that renders a single flipping card
// used in Amagama’s word matching game.
//
// RESPONSIBILITIES
// • Displays card front/back visuals with flip animation.
// • Synchronizes animation state with [CardItem.isFaceUp].
// • Disables taps while animating or when matched.
// • Triggers visual sparkle overlay when matched.
//
// DEPENDENCIES
// • [FlipAnimationMixin] for 3D rotation logic.
// • [CardItem] model for card state.
// • [SparkleLayer] for reward animation overlay.
//

import 'package:flutter/material.dart';
import 'package:amagama/mixins/index.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/widgets/sparkle_layer.dart';

class MatchFlipCard extends StatefulWidget {
  final CardItem card;
  final GlobalKey sparkleKey;
  final VoidCallback onTap;
  final double avatarScale;

  const MatchFlipCard({
    super.key,
    required this.card,
    required this.sparkleKey,
    required this.onTap,
    this.avatarScale = 0.8,
  });

  @override
  State<MatchFlipCard> createState() => _MatchFlipCardState();
}

class _MatchFlipCardState extends State<MatchFlipCard>
    with SingleTickerProviderStateMixin, FlipAnimationMixin<MatchFlipCard> {
  @override
  void initState() {
    super.initState();
    initFlipAnimation();

    // Sync initial visual state with model
    flipController.value = widget.card.isFaceUp ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(MatchFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateFlip(widget.card.isFaceUp);
  }

  @override
  void dispose() {
    disposeFlipAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (!flipAnim.isAnimating && !widget.card.isMatched)
          ? widget.onTap
          : null,
      child: AnimatedBuilder(
        animation: flipAnim,
        builder: (context, _) {
          final angle = flipAnim.value * 3.1416;
          final isFront = angle <= 3.1416 / 2;

          return Transform(
            alignment: Alignment.center,
            transform: buildFlipTransform(angle),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isFront)
                  _buildCardFront(widget.card)
                else
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.1416),
                    child: _buildCardBack(),
                  ),
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: SparkleLayer(key: widget.sparkleKey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🧩 Card Front (Avatar + Word)
  Widget _buildCardFront(CardItem card) {
    final imageAsset = 'assets/images/${card.word.toLowerCase()}.png';

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: card.isMatched
              ? [Colors.green.shade300, Colors.green.shade500]
              : [Colors.orange.shade100, Colors.orange.shade300],
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
          widthFactor: widget.avatarScale,
          heightFactor: widget.avatarScale,
          child: ClipOval(
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Text('🧩', style: TextStyle(fontSize: 28)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔒 Card Back (when face-down)
  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueGrey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.help_outline_rounded,
          size: 36,
          color: Colors.black54,
        ),
      ),
    );
  }
}