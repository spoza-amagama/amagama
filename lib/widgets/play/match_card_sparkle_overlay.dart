// 📄 lib/widgets/play/match_card_sparkle_overlay.dart
//
// ✨ MatchCardSparkleOverlay
// ------------------------------------------------------------
// Displays a sparkle burst whenever the card becomes matched.
// Uses [SparkleLayer] for visual sparkle effect.
// Automatically animates on match and fades away gracefully.

import 'package:flutter/material.dart';
import 'package:amagama/widgets/sparkle_layer.dart';

class MatchCardSparkleOverlay extends StatefulWidget {
  final bool active;
  final Duration duration;

  const MatchCardSparkleOverlay({
    super.key,
    required this.active,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<MatchCardSparkleOverlay> createState() =>
      _MatchCardSparkleOverlayState();
}

class _MatchCardSparkleOverlayState extends State<MatchCardSparkleOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _wasActive = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant MatchCardSparkleOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When card becomes matched, play sparkle burst
    if (widget.active && !_wasActive) {
      _controller.forward(from: 0);
      _wasActive = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(CurveTween(curve: Curves.easeOut)),
      child: IgnorePointer(
        ignoring: true,
        child: SparkleLayer(key: GlobalKey<SparkleLayerState>()),
      ),
    );
  }
}
