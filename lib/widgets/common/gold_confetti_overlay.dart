// 📄 lib/widgets/common/gold_confetti_overlay.dart
//
// 🎉 GoldConfettiOverlay — lightweight celebratory overlay.
//
// Usage:
//   GoldConfettiOverlay(
//     trigger: game.trophies.justUnlockedGold,
//     child: YourScreenBody(),
//   )
//
// Shows a brief golden confetti shimmer over the screen when [trigger] is
// true. Designed to be cheap and not depend on GameController directly.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

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

class _GoldConfettiOverlayState extends State<GoldConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  bool _show = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant GoldConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Start a one-shot animation whenever trigger flips from false -> true.
    if (!oldWidget.trigger && widget.trigger) {
      _playOnce();
    }
  }

  Future<void> _playOnce() async {
    setState(() => _show = true);
    await _controller.forward(from: 0);
    if (mounted) {
      setState(() => _show = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return widget.child;

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: FadeTransition(
              opacity: _opacity,
              child: _ConfettiLayer(),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Simple decorative confetti layer (no external deps).
// ─────────────────────────────────────────────────────────────

class _ConfettiLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gold = AmagamaColors.warning;
    final accent = AmagamaColors.accent;
    final softOverlay =
        AmagamaColors.textPrimary.withValues(alpha: 0.12);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            softOverlay,
            Colors.transparent,
            softOverlay,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomPaint(
        painter: _ConfettiPainter(
          primary: gold,
          secondary: accent,
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final Color primary;
  final Color secondary;

  _ConfettiPainter({
    required this.primary,
    required this.secondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintPrimary = Paint()
      ..color = primary
      ..style = PaintingStyle.fill;

    final paintSecondary = Paint()
      ..color = secondary
      ..style = PaintingStyle.fill;

    // A few simple "confetti" dots / rectangles spread around.
    final dots = <Offset>[
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.6),
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.85, size.height * 0.75),
    ];

    for (var i = 0; i < dots.length; i++) {
      final paint = i.isEven ? paintPrimary : paintSecondary;
      final rect = Rect.fromCenter(
        center: dots[i],
        width: 10,
        height: 4,
      );
      canvas.save();
      canvas.translate(dots[i].dx, dots[i].dy);
      canvas.rotate(0.4 * (i.isEven ? 1 : -1));
      canvas.translate(-dots[i].dx, -dots[i].dy);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
  }
}