// 📄 lib/widgets/sentence_header.dart
//
// 🪶 SentenceHeader (Responsive)
// ------------------------------------------------------------
// Displays "Your Sentence" title and one responsive sentence bubble.
// Dynamically scales text size by sentence length and screen width.

import 'package:flutter/material.dart';

class SentenceHeader extends StatelessWidget {
  final String text;
  final AnimationController controller;

  const SentenceHeader({
    super.key,
    required this.text,
    required this.controller,
  });

  double _dynamicFontSize(BuildContext context, String text) {
    final width = MediaQuery.of(context).size.width;
    final base = width < 380 ? 20.0 : width < 500 ? 24.0 : 28.0;

    // Reduce font slightly for longer sentences
    final lengthFactor = (text.length / 40).clamp(0.8, 1.3);
    final scaled = base / lengthFactor;
    return scaled.clamp(18.0, 34.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmall = MediaQuery.of(context).size.height < 700;
    final fontSize = _dynamicFontSize(context, text);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🏷️ Title label
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            'Your Sentence',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ),

        // 💬 Sentence bubble (auto-sized)
        Container(
          margin: EdgeInsets.only(bottom: isSmall ? 8 : 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return Transform.scale(
                scale: 0.95 + (controller.value * 0.1),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize,
                    height: 1.2,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
