// 📄 lib/widgets/home/content/home_sentence_carousel_item.dart
//
// HomeSentenceCarouselItem — displays a sentence preview.
// ------------------------------------------------------------
// • If locked → shows a large padlock as a watermark.
// • If unlocked → shows sentence normally.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';

class HomeSentenceCarouselItem extends StatelessWidget {
  final int index;
  final String text;

  const HomeSentenceCarouselItem({
    super.key,
    required this.index,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final isLocked = !game.sentences.isUnlocked(index);

    return Stack(
      children: [
        // 🔹 Sentence text / normal content
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AmagamaColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 4),
                color: Colors.black26,
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AmagamaTypography.titleStyle.copyWith(
              fontSize: 24,
              color: isLocked
                  ? AmagamaColors.textSecondary
                  : AmagamaColors.textPrimary,
            ),
          ),
        ),

        // 🔐 WATERMARK PADLOCK FOR LOCKED SENTENCES
        if (isLocked)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Icon(
                  Icons.lock_rounded,
                  size: 96,               // Large padlock
                  color: Colors.black12,  // Watermark effect
                ),
              ),
            ),
          ),
      ],
    );
  }
}