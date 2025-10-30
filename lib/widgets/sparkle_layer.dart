// /lib/widgets/sparkle_layer.dart
import 'dart:math';
import 'package:flutter/material.dart';

/// Sparkle layer for floating animated stars.
/// Call [triggerSparkles] to create a burst effect.
class SparkleLayer extends StatefulWidget {
  const SparkleLayer({super.key});

  @override
  State<SparkleLayer> createState() => SparkleLayerState();
}

class SparkleLayerState extends State<SparkleLayer>
    with TickerProviderStateMixin {
  final List<_Sparkle> _sparkles = [];
  final Random _rand = Random();

  /// Triggers a burst of sparkles that float upward and fade.
  void triggerSparkles() {
    final newSparkles = List.generate(6, (_) {
      final duration = 1000 + _rand.nextInt(500);
      return _Sparkle(
        x: (_rand.nextDouble() * 2 - 1) * 60, // horizontal ±60px
        y: (_rand.nextDouble() * 2 - 1) * 20, // vertical ±20px
        size: 10 + _rand.nextDouble() * 10,
        rotation: _rand.nextDouble() * pi,
        controller: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: duration),
        ),
      );
    });

    for (final s in newSparkles) {
      s.controller.forward();
      s.controller.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _sparkles.remove(s));
          s.controller.dispose();
        }
      });
    }

    setState(() => _sparkles.addAll(newSparkles));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: _sparkles.map((s) {
        return AnimatedBuilder(
          animation: s.controller,
          builder: (context, _) {
            final progress = s.controller.value;
            final opacity = 1.0 - progress;
            final offsetY = s.y - (progress * 25); // float upward
            final sparkleAlpha = 0.8 + 0.2 * _rand.nextDouble();

            return Positioned(
              left: s.x,
              top: offsetY,
              child: Transform.rotate(
                angle: s.rotation + progress * pi / 4,
                child: Opacity(
                  opacity: opacity,
                  child: Icon(
                    Icons.star_rounded,
                    color: _colorWithAlpha(Colors.amber.shade300, sparkleAlpha),
                    size: s.size,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  /// 🧩 Helper: safely apply alpha depending on Flutter SDK
  Color _colorWithAlpha(Color base, double alpha) {
    try {
      // For Flutter 3.22+ (new API)
      // ignore: deprecated_member_use
      return base.withValues(alpha: alpha);
    } catch (_) {
      // For older Flutter SDKs
      return base.withOpacity(alpha);
    }
  }

  @override
  void dispose() {
    for (final s in _sparkles) {
      s.controller.dispose();
    }
    _sparkles.clear();
    super.dispose();
  }
}

class _Sparkle {
  final double x, y, size, rotation;
  final AnimationController controller;

  _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.rotation,
    required this.controller,
  });
}
