// 📄 lib/widgets/game_over/confetti_layer.dart
//
// Animated confetti painter layer using AmagamaColors.

import 'dart:math' show Random, pi;
import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class ConfettiLayer extends StatefulWidget {
  const ConfettiLayer({super.key});

  @override
  State<ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<ConfettiLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        painter: _ConfettiPainter(animationValue: _controller.value),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double animationValue;
  final Random _rand = Random();

  _ConfettiPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      AmagamaColors.primary,
      AmagamaColors.secondary,
      AmagamaColors.accent,
      AmagamaColors.warning,
      AmagamaColors.success,
    ];

    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 80; i++) {
      final progress = (i / 80 + animationValue) % 1.0;
      final x = _rand.nextDouble() * size.width;
      final y = progress * size.height;
      final color = colors[_rand.nextInt(colors.length)];
      final angle = _rand.nextDouble() * pi;
      final sizeBox = _rand.nextDouble() * 10 + 4;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      paint.color = color.withValues(alpha: 0.8);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: sizeBox, height: sizeBox / 2),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
