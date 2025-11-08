// 📄 lib/widgets/play/sentence_stack.dart
//
// ✨ SentenceStack
// ------------------------------------------------------------
// Combines the responsive [SentenceHeader] with sparkle overlay.
// Provides animation via [AnimationController].
// No internal duplicate sentence text.

import 'package:flutter/material.dart';
import 'package:amagama/widgets/sparkle_layer.dart';
import 'package:amagama/widgets/sentence_header.dart';

class SentenceStack extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final GlobalKey<SparkleLayerState> sparkleKey;

  const SentenceStack({
    super.key,
    required this.text,
    required this.controller,
    required this.sparkleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ✅ Use SentenceHeader for actual text display
        SentenceHeader(
          text: text,
          controller: controller,
        ),

        // ✨ Sparkle overlay
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: SparkleLayer(key: sparkleKey),
          ),
        ),
      ],
    );
  }
}
