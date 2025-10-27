// /lib/widgets/round_card.dart
import 'package:flutter/material.dart';
import '../state/index.dart';
import 'dart:math' as math;

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
  bool _hasPulsed = false; // ✅ ensures pulse happens only once

  late final AnimationController _flipController;
  late final AnimationController _pulseController;
  late final Animation<double> _flipAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _flipAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _pulseAnimation =
        CurvedAnimation(parent: _pulseController, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(RoundCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔄 Flip when faceUp changes
    if (widget.item.isFaceUp != _isFlipped) {
      if (widget.item.isFaceUp) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
      _isFlipped = widget.item.isFaceUp;
    }

    // 💚 Pulse once on first match
    if (widget.item.isMatched && !_hasPulsed) {
      _pulseController.forward(from: 0);
      _hasPulsed = true;
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _pulseController.dispose();
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

    final textColor =
        widget.item.isMatched ? Colors.white : Colors.black.withOpacity(0.85);

    final isFlashingRed = widget.item.shouldFlashRed;
    final isShaking = widget.item.shouldShake;
    final scale = 1 + _pulseAnimation.value;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipController, _pulseController]),
        builder: (context, child) {
          final isFront = _flipAnimation.value < math.pi / 2;

          // Shake offset (sin wave oscillation)
          final shakeOffset = isShaking
              ? math.sin(DateTime.now().millisecondsSinceEpoch * 0.05) * 6
              : 0.0;

          return Transform.translate(
            offset: Offset(shakeOffset, 0),
            child: Transform.scale(
              scale: scale,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_flipAnimation.value),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: baseColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // FRONT — avatar
                      IgnorePointer(
                        ignoring: !isFront,
                        child: Opacity(
                          opacity: isFront ? 1 : 0,
                          child: ClipOval(
                            child: Padding(
                              padding: EdgeInsets.all(widget.size * 0.15),
                              child: Image.asset(
                                widget.item.avatarPath,
                                fit: BoxFit.contain,
                                width: widget.size * widget.avatarScale,
                                height: widget.size * widget.avatarScale,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // BACK — word (non-mirrored)
                      IgnorePointer(
                        ignoring: isFront,
                        child: Opacity(
                          opacity: isFront ? 0 : 1,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(math.pi),
                            child: ClipOval(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                child: Text(
                                  widget.item.word,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: widget.size * 0.22,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.25),
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

                      // 🔴 FLASH overlay (mismatch)
                      AnimatedOpacity(
                        opacity: isFlashingRed ? 1 : 0,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent.withOpacity(0.6),
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
