// 📄 lib/widgets/sparkle_layer.dart
//
// ✨ SparkleLayer — lightweight celebratory particle effect
// Used on card flip & match. Ultra-cheap and mobile-safe.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SparkleLayer extends StatefulWidget {
  const SparkleLayer({super.key});

  @override
  SparkleLayerState createState() => SparkleLayerState();
}

class SparkleLayerState extends State<SparkleLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late List<_Sparkle> _particles;

  final Random _rand = Random();
  static const int _count = 12;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _generateParticles();
  }

  // Rebuild particles + replay animation when triggered
  void triggerSparkles() {
    _generateParticles();
    _ctrl.forward(from: 0);
  }

  void _generateParticles() {
    _particles = List.generate(
      _count,
      (_) => _Sparkle(
        angle: _r(0, pi * 2),
        velocity: _r(18, 34),
        size: _r(5.5, 11.5),
      ),
    );
  }

  double _r(double min, double max) =>
      min + _rand.nextDouble() * (max - min);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            painter: _SparklePainter(
              progress: _ctrl.value,
              particles: _particles,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PARTICLE
// ---------------------------------------------------------------------------

class _Sparkle {
  final double angle;
  final double velocity;
  final double size;

  const _Sparkle({
    required this.angle,
    required this.velocity,
    required this.size,
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
    final fade = Curves.easeOut.transform(1 - progress);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AmagamaColors.warning.withValues(alpha: fade);

    final center = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      final distance = p.velocity * progress;

      final dx = cos(p.angle) * distance;
      final dy = sin(p.angle) * distance;

      final pos = center.translate(dx, dy);
      canvas.drawCircle(pos, p.size * fade, paint);
    }
  }

  @override
  bool shouldRepaint(_SparklePainter old) =>
      old.progress != progress;
}