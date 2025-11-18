// 📄 lib/widgets/home/home_sentence_carousel.dart
//
// 🎠 HomeSentenceCarousel — infinite, snapping sentence carousel.
// • Center card scaling
// • Infinite scroll via virtual index
// • Respects GameController locking/progress
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/widgets/home/sentence_card.dart';

class HomeSentenceCarousel extends StatefulWidget {
  const HomeSentenceCarousel({super.key});

  @override
  State<HomeSentenceCarousel> createState() => _HomeSentenceCarouselState();
}

class _HomeSentenceCarouselState extends State<HomeSentenceCarousel> {
  static const int _kVirtualItemCount = 1000000;

  late final PageController _controller;

  int _computeInitialPage(GameController game) {
    final int realIndex = game.currentSentenceIndex;
    final int len = sentences.length;
    if (len == 0) return 0;
    final int mid = _kVirtualItemCount ~/ 2;
    final int base = mid - (mid % len);
    return base + realIndex;
  }

  @override
  void initState() {
    super.initState();
    final game = context.read<GameController>();
    _controller = PageController(
      viewportFraction: 0.78,
      initialPage: _computeInitialPage(game),
    );
  }

  int _realIndex(int virtualIndex) {
    final len = sentences.length;
    if (len == 0) return 0;
    final int result = virtualIndex % len;
    return result < 0 ? result + len : result;
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return PageView.builder(
      controller: _controller,
      physics: const PageScrollPhysics(),
      itemCount: _kVirtualItemCount,
      onPageChanged: (virtualPage) {
        final realIndex = _realIndex(virtualPage);
        game.setViewSentenceIndex(realIndex);
        if (game.isSentenceUnlocked(realIndex)) {
          game.setCurrentSentenceIndex(realIndex);
        }
      },
      itemBuilder: (context, virtualIndex) {
        final int index = _realIndex(virtualIndex);
        final sentence = sentences[index];

        final bool isActive = index == game.currentSentenceIndex;
        final bool isUnlocked = game.isSentenceUnlocked(index);

        bool isCompleted = false;
        if (index >= 0 && index < game.progress.length) {
          isCompleted =
              game.progress[index].cyclesCompleted >= game.cyclesTarget;
        }

        final bool isLocked = !isUnlocked;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double scale = 1.0;
            if (_controller.position.haveDimensions) {
              final page = _controller.page ?? _controller.initialPage.toDouble();
              final distance = (page - virtualIndex).abs();
              scale = (1.0 - distance * 0.25).clamp(0.8, 1.0);
            }
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: SentenceCard(
            sentenceText: sentence.text,
            isActive: isActive,
            isCompleted: isCompleted,
            isLocked: isLocked,
          ),
        );
      },
    );
  }
}
