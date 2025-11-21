// 📄 lib/widgets/common/index.dart
//
// GoldConfettiOverlay — wraps a child and shows a short confetti burst
// when [trigger] is true. Stateless for callers; internally manages
// a one-shot animation.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class GoldConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool trigger;

  const GoldConfettiOverlay({
    super.key,
    required this.child,
    required this.trigger,
  });

  @override
  State<GoldConfettiOverlay> createState() => _GoldConfettiOverlayState();
}

class _GoldConfettiOverlayState extends State<GoldConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;
  bool _active = false;
  final Random _rand = Random();
  late final List<_ConfettiPiece> _pieces;

  static const _count = 80;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progress = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    );

    _pieces = List.generate(
      _count,
      (i) => _ConfettiPiece(
        dx: _rand.nextDouble(),
        dyStart: _rand.nextDouble() * -0.2,
        length: 0.4 + _rand.nextDouble() * 0.4,
        size: 4 + _rand.nextDouble() * 4,
        tilt: (_rand.nextDouble() - 0.5) * 0.6,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant GoldConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _start();
    }
  }

  void _start() {
    setState(() => _active = true);
    _ctrl
      ..stop()
      ..forward(from: 0).whenComplete(() {
        if (mounted) {
          setState(() => _active = false);
        }
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_active) return widget.child;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _progress,
            builder: (context, _) {
              return CustomPaint(
                painter: _GoldConfettiPainter(
                  progress: _progress.value,
                  pieces: _pieces,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ConfettiPiece {
  final double dx;
  final double dyStart;
  final double length;
  final double size;
  final double tilt;

  const _ConfettiPiece({
    required this.dx,
    required this.dyStart,
    required this.length,
    required this.size,
    required this.tilt,
  });
}

class _GoldConfettiPainter extends CustomPainter {
  final double progress;
  final List<_ConfettiPiece> pieces;

  _GoldConfettiPainter({
    required this.progress,
    required this.pieces,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseColors = [
      AmagamaColors.warning,
      AmagamaColors.secondary,
      AmagamaColors.accent.withValues(alpha: 0.9),
    ];

    for (var i = 0; i < pieces.length; i++) {
      final p = pieces[i];
      final color = baseColors[i % baseColors.length]
          .withValues(alpha: (1 - progress).clamp(0.0, 1.0));

      final dx = p.dx * size.width;
      final dy = (p.dyStart + p.length * progress) * size.height;

      final rect = Rect.fromCenter(
        center: Offset(dx, dy),
        width: p.size,
        height: p.size * 2,
      );

      final r = Rect.fromCenter(
        center: rect.center,
        width: rect.width,
        height: rect.height,
      );

      final paint = Paint()..color = color;
      canvas.save();
      canvas.translate(r.center.dx, r.center.dy);
      canvas.rotate(p.tilt + progress * pi * 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: r.width,
            height: r.height,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _GoldConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pieces != pieces;
}