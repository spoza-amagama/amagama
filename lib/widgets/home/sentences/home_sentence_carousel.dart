// 📄 lib/widgets/home/sentences/home_sentence_carousel.dart
//
// 🎠 HomeSentenceCarousel — infinite looping + clean scaling
// ------------------------------------------------------------
// • Infinite looping (virtual pages)
// • Smooth snap-to-center scaling
// • Locked state handled ONLY by SentenceCard
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';

import '../home_sentence_page_controller.dart';
import 'sentence_card.dart';

class HomeSentenceCarousel extends StatelessWidget {
  const HomeSentenceCarousel({super.key});

  static const int _loopFactor = 10000;

  int _mapPageToReal(int page, int total) {
    return total == 0 ? 0 : page % total;
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final total = sentences.length;

    if (total == 0) {
      return const Center(child: Text('No sentences'));
    }

    final initialRealIndex = game.sentences.viewSentence;
    final initialPage = (total * _loopFactor ~/ 2) + initialRealIndex;

    return HomeSentencePageController(
      createController: () => PageController(
        initialPage: initialPage,
        viewportFraction: 0.78,
      ),
      builder: (pageController) {
        return PageView.builder(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (page) {
            final realIndex = _mapPageToReal(page, total);
            game.updateViewSentence(realIndex);
          },
          itemBuilder: (context, page) {
            final realIndex = _mapPageToReal(page, total);
            final sentence = sentences[realIndex];

            final isUnlocked = game.sentences.isUnlocked(realIndex);
            final isActive = realIndex == game.sentences.viewSentence;

            // ------------------------------------------------------------
            // SCALE ANIMATION
            // ------------------------------------------------------------
            double pageOffset;
            if (pageController.hasClients) {
              pageOffset = pageController.page ??
                  pageController.initialPage.toDouble();
            } else {
              pageOffset = pageController.initialPage.toDouble();
            }

            final distance = (pageOffset - page).abs();
            final snapScale =
                1.0 - (distance * 0.12).clamp(0.0, 0.3);

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: snapScale),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
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