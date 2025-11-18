// 📄 lib/widgets/home/home_background.dart
//
// 🌅 HomeBackground — animated African-themed gradient with fade-in
// ------------------------------------------------------------
// • Loops warm sunrise hues subtly over time
// • Adds fade-in animation on mount (1s)
// • Designed to evoke the shifting light of dawn on the savannah
// ------------------------------------------------------------

import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeBackground extends StatefulWidget {
  const HomeBackground({super.key});

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // 🎨 Animate gradient shift (loop)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // 🌤️ Fade in on load (first second only)
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOut),
      ),
    );
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
      builder: (context, _) {
        final t = _controller.value;
        final angle = t * 2 * math.pi;

        // 🎨 Warm shifting hues
        final color1 = HSVColor.fromAHSV(
          1.0,
          (30 + t * 20) % 360,
          0.6,
          1.0,
        ).toColor();

        final color2 = HSVColor.fromAHSV(
          1.0,
          (10 + t * 40) % 360,
          0.7,
          0.95,
        ).toColor();

        return FadeTransition(
          opacity: _fadeIn,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color1, color2],
                transform: GradientRotation(angle / 8),
              ),
            ),
          ),
        );
      },
    );
  }
}