// lib/widgets/animated_sentence_text.dart
import 'package:flutter/material.dart';

/// Displays the sentence text with pulse (scale + color) animation.
class AnimatedSentenceText extends StatelessWidget {
  final String text;
  final AnimationController controller;

  const AnimatedSentenceText({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final scaleAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    final colorAnim = ColorTween(
      begin: const Color(0xFF6D4C41),
      end: const Color(0xFFFFB300),
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.scale(
          scale: scaleAnim.value,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  color: colorAnim.value,
                  letterSpacing: 0.6,
                  height: 1.4,
                  shadows: const [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
          ),
        );
      },
    );
  }
}
