// 📄 lib/widgets/common/gold_confetti_overlay.dart
//
// 🎉 GoldConfettiOverlay
// ------------------------------------------------------------
// • Wraps any child widget and shows a gold confetti burst
//   when `trigger` becomes true.
// • Written for confetti: ^0.7.0 (uses ConfettiControllerState).
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class GoldConfettiOverlay extends StatefulWidget {
  final bool trigger;
  final Widget child;

  const GoldConfettiOverlay({
    super.key,
    required this.trigger,
    required this.child,
  });

  @override
  State<GoldConfettiOverlay> createState() => _GoldConfettiOverlayState();
}

class _GoldConfettiOverlayState extends State<GoldConfettiOverlay> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void didUpdateWidget(GoldConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ⭐ Correct API for confetti 0.7.0:
    // ConfettiController.state is an enum: ConfettiControllerState
    if (widget.trigger &&
        _controller.state != ConfettiControllerState.playing) {
      _controller.play();
    }

    if (!widget.trigger &&
        _controller.state == ConfettiControllerState.playing) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          ignoring: true,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.06,
              numberOfParticles: 20,
              maxBlastForce: 16,
              minBlastForce: 6,
              colors: const [
                Colors.amber,
                Colors.yellow,
                Colors.deepOrange,
              ],
            ),
          ),
        ),
      ],
    );
  }
}