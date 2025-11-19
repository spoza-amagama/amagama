// 📄 lib/widgets/sparkle_layer.dart
//
// ✨ SparkleLayer
// ------------------------------------------------------------
// A lightweight particle overlay used when a card is flipped
// or matched. Designed for smooth performance and Amagama theme consistency.
//
// RESPONSIBILITIES
// • Draws a small set of drifting sparkles.
// • Automatically animates in/out (no interaction).
// • Uses warm gold tones to match the trophy palette.
//
// SAFE FOR LOW-END DEVICES
// • No shaders
// • No expensive compositing
// • No timing loops outside Ticker
//

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SparkleLayer extends StatefulWidget {
  const SparkleLayer({super.key});

  @override
  State<SparkleLayer> createState() => _SparkleLayerState();
}

class _SparkleLayerState extends State<SparkleLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final Random _rand = Random();

  // sparkle seeds
  late final List<_Sparkle> _particles;

  static const int _count = 12;

  @override
  void initState() {
    super.initState();

    // Controller runs for a single one-shot burst
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    // Generate randomized sparkle seeds
    _particles = List.generate(
      _count,
      (_) => _Sparkle(
        dx: _r(-0.5, 0.5),
        dy: _r(-0.5, 0.5),
        size: _r(6.5, 13.0),
        velocity: _r(12, 28),
        angle: _r(0, pi * 2),
      ),
    );
  }

  double _r(double min, double max) => min + _rand.nextDouble() * (max - min);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _SparklePainter(
              progress: _ctrl.value,
              particles: _particles,
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PARTICLE MODEL
// ---------------------------------------------------------------------------

class _Sparkle {
  final double dx;
  final double dy;
  final double size;
  final double velocity;
  final double angle;

  const _Sparkle({
    required this.dx,
    required this.dy,
    required this.size,
    required this.velocity,
    required this.angle,
  });
}

// ---------------------------------------------------------------------------
// PAINTER
// ---------------------------------------------------------------------------

class _SparklePainter extends CustomPainter {
  final double progress;
  final List<_Sparkle> particles;

  _SparklePainter({
    required this.progress,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AmagamaColors.warning.withValues(alpha: (1 - progress));

    final center = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      final dist = p.velocity * progress;

      final dx = p.dx * dist * cos(p.angle);
      final dy = p.dy * dist * sin(p.angle);

      final sparkPos = center.translate(dx, dy);

      canvas.drawCircle(sparkPos, p.size * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      oldDelegate.progress != progress;
}