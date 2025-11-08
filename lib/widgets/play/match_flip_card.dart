// 📄 lib/widgets/play/match_flip_card.dart
//
// 🎴 MatchFlipCard — circular flip with shared mismatch signal
// ------------------------------------------------------------
// • Smooth Y-axis flip animation.
// • Matched cards turn green and stay up.
// • Both mismatched cards flash red (from GameController signal).
// • Fully responsive and independent of sparkleKey.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/state/game_controller.dart';

class MatchFlipCard extends StatefulWidget {
  final CardItem card;
  final VoidCallback onTap;

  const MatchFlipCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  State<MatchFlipCard> createState() => _MatchFlipCardState();
}

class _MatchFlipCardState extends State<MatchFlipCard>
    with SingleTickerProviderStateMixin {
  bool _flashRed = false;

  @override
  void initState() {
    super.initState();

    // Listen globally for mismatched card signals
    final game = context.read<GameController>();
    game.mismatchedCards.addListener(_onMismatchSignal);
  }

  @override
  void dispose() {
    final game = context.read<GameController>();
    game.mismatchedCards.removeListener(_onMismatchSignal);
    super.dispose();
  }

  void _onMismatchSignal() {
    final game = context.read<GameController>();
    final mismatchIds = game.mismatchedCards.value;

    if (mismatchIds.contains(widget.card.id)) {
      setState(() => _flashRed = true);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _flashRed = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        layoutBuilder: (current, previous) =>
            Stack(children: [if (current != null) current, ...previous]),
        transitionBuilder: (child, animation) {
          final rotate =
              Tween<double>(begin: math.pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, childWidget) {
              final isUnder =
                  (childWidget?.key != ValueKey(widget.card.isFaceUp));
              final angle =
                  isUnder ? math.min(rotate.value, math.pi / 2) : rotate.value;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: childWidget,
              );
            },
          );
        },
        child: widget.card.isFaceUp
            ? _buildFront(key: const ValueKey(true))
            : _buildBack(key: const ValueKey(false)),
      ),
    );
  }

  // 🂠 Back (animal avatar)
  Widget _buildBack({Key? key}) {
    final avatarIndex = (widget.card.id % 30) + 1;
    final avatarFile =
        'assets/avatars/animal_${avatarIndex.toString().padLeft(2, '0')}.png';

    final bgColor = _flashRed
        ? Colors.redAccent
        : Colors.orangeAccent; // normal orange back

    return AnimatedContainer(
      key: key,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          avatarFile,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) =>
              const Icon(Icons.extension, color: Colors.green, size: 36),
        ),
      ),
    );
  }

  // 🂡 Front (word text)
  Widget _buildFront({Key? key}) {
    final color = widget.card.isMatched
        ? Colors.lightGreen
        : Colors.white;

    return AnimatedContainer(
      key: key,
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
            widget.card.word,
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
