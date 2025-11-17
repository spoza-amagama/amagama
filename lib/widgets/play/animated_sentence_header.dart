// 📄 lib/widgets/play/animated_sentence_header.dart
//
// Animated header wrapping SentenceStack in a themed container.
//
// ✅ Fixes:
// • Removed typed GlobalKey<SparkleLayerState> (private class → inaccessible)
// • Removed duplicate import
// • Ensures SentenceStack gets correct parameters
// • Keeps consistent African theme styling
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../../theme/index.dart';
import 'package:amagama/widgets/play/sentence_stack.dart';

class AnimatedSentenceHeader extends StatelessWidget {
  final AnimationController controller;
  final GlobalKey sparkleKey; // untyped key since SparkleLayerState is private
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
      child: SentenceStack(
        text: text,
        controller: controller,
        sparkleKey: sparkleKey,
      ),
    );
  }
}