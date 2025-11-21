// 📄 lib/widgets/game_over/confetti_layer.dart
//
// 🎊 ConfettiLayer — soft decorative confetti overlay for the Game Over screen.
// Purely visual: no game state dependencies.

import 'package:flutter/material.dart';

class ConfettiLayer extends StatelessWidget {
  final Widget child;

  const ConfettiLayer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        IgnorePointer(
          child: CustomPaint(
            painter: _ConfettiPainter(),
            size: Size.infinite,
          ),
        ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = <Color>[
      const Color(0xFFFFC857),
      const Color(0xFF8AC926),
      const Color(0xFF1982C4),
      const Color(0xFFFF595E),
    ];

    final paint = Paint();
    final randomOffsets = <Offset>[
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.18),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.9, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.7, size.height * 0.82),
    ];

    for (var i = 0; i < randomOffsets.length; i++) {
      paint.color = colors[i % colors.length].withValues(alpha: 0.35);
      canvas.drawCircle(randomOffsets[i], 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}