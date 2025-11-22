// 📄 lib/widgets/home/sentences/home_sentence_carousel.dart
//
// 🎠 HomeSentenceCarousel — clean week-free carousel.
// Uses HomeSentencePageController to manage PageController lifecycle.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';

import '../home_sentence_page_controller.dart';
import 'sentence_card.dart'; // ✅ correct relative path

class HomeSentenceCarousel extends StatelessWidget {
  const HomeSentenceCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final total = sentences.length;

    return HomeSentencePageController(
      builder: (controller) {
        final currentIndex = game.sentences.viewSentence;

        return PageView.builder(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          onPageChanged: game.sentences.setView,
          itemCount: total,
          itemBuilder: (context, index) {
            final sentence = sentences[index];
            final isUnlocked = game.sentences.isUnlocked(index);
            final isActive = index == currentIndex;

            return AnimatedScale(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              scale: isActive ? 1.0 : 0.9,
              child: SentenceCard(
                sentenceText: sentence.text,
                isActive: isActive,
                isCompleted: isUnlocked,
                isLocked: !isUnlocked,
              ),
            );
          },
        );
      },
    );
  }
}
