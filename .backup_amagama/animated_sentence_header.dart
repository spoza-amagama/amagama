// 📄 lib/widgets/play/animated_sentence_header.dart
//
// Animated header combining SentenceStack (text) with SparkleLayer (controller).

import 'package:flutter/material.dart';
import '../../../theme/index.dart';
import '../sparkle_layer.dart';
import 'package:amagama/widgets/play/sentence_stack.dart';

class AnimatedSentenceHeader extends StatelessWidget {
  final AnimationController controller;
  final GlobalKey<SparkleLayerState> sparkleKey;
  final String text;

  const AnimatedSentenceHeader({
    super.key,
    required this.controller,
    required this.sparkleKey,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AmagamaSpacing.sm),
      decoration: BoxDecoration(
        color: AmagamaColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AmagamaSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AmagamaColors.primary.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SentenceStack(text: text, controller: controller, sparkleKey: sparkleKey),
          SparkleLayer(key: sparkleKey, controller: controller),
        ],
      ),
    );
  }
}
