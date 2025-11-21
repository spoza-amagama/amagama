// 📄 lib/widgets/home/home_sentence_carousel.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';

import 'sentence_card.dart';

class HomeSentenceCarousel extends StatefulWidget {
  const HomeSentenceCarousel({super.key});

  @override
  State<HomeSentenceCarousel> createState() => _HomeSentenceCarouselState();
}

class _HomeSentenceCarouselState extends State<HomeSentenceCarousel> {
  PageController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final game = context.read<GameController>();
    final initial = game.sentences.viewSentence;

    _controller ??= PageController(
      viewportFraction: 0.78,
      initialPage: initial,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    final total = sentences.length;
    final currentIndex = game.sentences.viewSentence;

    return PageView.builder(
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (page) {
        game.sentences.setView(page);
      },
      itemCount: total,
      itemBuilder: (context, index) {
        final sentence = sentences[index];
        final isUnlocked = game.sentences.isUnlocked(index);
        final prog = game.progress.byIndex(index);
        final isCompleted =
            prog.cyclesCompleted >= game.cycles.cyclesTarget;
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