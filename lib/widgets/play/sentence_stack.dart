// 📂 lib/widgets/play/sentence_stack.dart
import 'package:flutter/material.dart';
import 'package:amagama/widgets/sentence_header.dart';
import 'package:amagama/widgets/sparkle_layer.dart';

/// ✨ SentenceStack
/// Combines the sentence header animation and sparkle overlay.
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
        SentenceHeader(text: text, controller: controller),
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
