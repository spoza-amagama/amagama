// 📄 lib/widgets/home/home_sentence_carousel.dart
//
// 🎠 HomeSentenceCarousel — snapping sentence carousel with lock state.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'sentence_card.dart';

class HomeSentenceCarousel extends StatefulWidget {
  const HomeSentenceCarousel({super.key});

  @override
  State<HomeSentenceCarousel> createState() =>
      _HomeSentenceCarouselState();
}

class _HomeSentenceCarouselState extends State<HomeSentenceCarousel> {
  PageController? _controller;
  int _currentPage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final game = context.read<GameController>();
    final initial = game.sentences.viewSentence;

    if (_controller == null) {
      _currentPage = initial;
      _controller = PageController(
        viewportFraction: 0.78,
        initialPage: initial,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    final total = game.sentences.total;
    final currentIndex = game.sentences.viewSentence;

    return PageView.builder(
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (page) {
        // Prevent scrolling to locked sentences
        if (!game.sentences.isUnlocked(page)) {
          // snap back
          _controller?.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
          return;
        }

        setState(() => _currentPage = page);
        game.sentences.setView(page);
      },
      itemCount: total,
      itemBuilder: (context, index) {
        final sentence = game.sentences.byIndex(index);
        final isUnlocked = game.sentences.isUnlocked(index);

        final prog = game.progress.byIndex(index);
        final cyclesTarget = game.cycles.cyclesTarget;
        final isCompleted = prog.cyclesCompleted >= cyclesTarget;

        final isActive = index == currentIndex;

        return AnimatedScale(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          scale: isActive ? 1.0 : 0.9,
          child: SentenceCard(
            sentenceText: sentence.text,
            isActive: isActive,
            isCompleted: isCompleted,
            isLocked: !isUnlocked,
          ),
        );
      },
    );
  }
}