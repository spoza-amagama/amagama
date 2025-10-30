// 📄 lib/widgets/round_card.dart
//
// 🌀 RoundCard
// ----------------------
// Purely visual, animated card widget used in the play grid.
// Handles flip, pulse, and shake animations for game cards.
// All game logic, audio, and state are handled externally
// by [CardFlipController] and [CardGridController].

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';

class RoundCard extends StatefulWidget {
  final CardItem item;
  final bool lockInput;
  final Future<void> Function() onFlip;
  final double size;
  final double avatarScale;

  const RoundCard({
    super.key,
    required this.item,
    required this.lockInput,
    required this.onFlip,
    this.size = 120,
    this.avatarScale = 0.8,
  });

  @override
  State<RoundCard> createState() => _RoundCardState();
}

class _RoundCardState extends State<RoundCard> with TickerProviderStateMixin {
  bool _isFlipped = false;
  bool _hasPulsed = false;

  late final AnimationController _flipCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _flipAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _flipAnim = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _pulseAnim = CurvedAnimation(
      parent: _pulseCtrl,
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(RoundCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔁 Flip animation sync
    if (widget.item.isFaceUp != _isFlipped) {
      if (widget.item.isFaceUp) {
        _flipCtrl.forward();
      } else {
        _flipCtrl.reverse();
      }
      _isFlipped = widget.item.isFaceUp;
    }

    // 💚 Pulse when matched for first time
    if (widget.item.isMatched && !_hasPulsed) {
      _pulseCtrl.forward(from: 0);
      _hasPulsed = true;
    }
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.lockInput || widget.item.isMatched) return;
    await widget.onFlip();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.item.isMatched
        ? Colors.green.shade600
        : Colors.yellow.shade200;

    final textColor = widget.item.isMatched
        ? Colors.white
        : Colors.black.withValues(alpha: 0.85);

    final isFlashingRed = widget.item.shouldFlashRed;
    final isShaking = widget.item.shouldShake;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipCtrl, _pulseCtrl]),
        builder: (context, _) {
          final isFront = _flipAnim.value < math.pi / 2;
          final shakeOffset = isShaking
              ? math.sin(DateTime.now().millisecondsSinceEpoch * 0.05) * 6
              : 0.0;
          final scale = 1 + _pulseAnim.value;

          return Transform.translate(
            offset: Offset(shakeOffset, 0),
            child: Transform.scale(
              scale: scale,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_flipAnim.value),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: baseColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 🖼️ FRONT — avatar image
                      IgnorePointer(
                        ignoring: !isFront,
                        child: Opacity(
                          opacity: isFront ? 1 : 0,
                          child: Padding(
                            padding: EdgeInsets.all(widget.size * 0.15),
                            child: ClipOval(
                              child: Image.asset(
                                widget.item.avatarPath ?? '',
                                fit: BoxFit.contain,
                                width: widget.size * widget.avatarScale,
                                height: widget.size * widget.avatarScale,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 🔤 BACK — text (word)
                      IgnorePointer(
                        ignoring: isFront,
                        child: Opacity(
                          opacity: isFront ? 0 : 1,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(math.pi),
                            child: ClipOval(
                              child: Container(
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  widget.item.word,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: widget.size * 0.22,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        offset: const Offset(1, 1),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 🔴 FLASH overlay for mismatched attempt
                      AnimatedOpacity(
                        opacity: isFlashingRed ? 1 : 0,
                        duration: const Duration(milliseconds: 120),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}