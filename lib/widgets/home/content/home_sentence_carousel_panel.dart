// 📄 lib/widgets/home/content/home_sentence_carousel_panel.dart
//
// HomeSentenceCarouselPanel — infinite, safe sentence carousel.
// ---------------------------------------------------------------------
// • Fake “endless” loop using a large page range + modulo
// • No scroll notification recursion (no animateToPage in listeners)
// • Locked sentences = grey with padlock
// • Active/unlocked = green
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/theme/index.dart';

class HomeSentenceCarouselPanel extends StatefulWidget {
  const HomeSentenceCarouselPanel({super.key});

  @override
  State<HomeSentenceCarouselPanel> createState() =>
      _HomeSentenceCarouselPanelState();
}

class _HomeSentenceCarouselPanelState extends State<HomeSentenceCarouselPanel> {
  static const int _loopMultiplier = 10000; // big enough to feel infinite

  late PageController _controller;
  bool _controllerInitialized = false;

  int get _sentenceCount => sentences.length;

  int _initialPage(int currentIndex) {
    // start roughly in the middle of the virtual range
    final middleBlock = (_loopMultiplier ~/ 2) * _sentenceCount;
    return middleBlock + currentIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controllerInitialized || _sentenceCount == 0) return;

    final game = context.read<GameController>();
    final viewIndex = game.sentences.viewSentence;

    _controller = PageController(
      viewportFraction: 0.78,
      initialPage: _initialPage(viewIndex),
    );

    _controllerInitialized = true;
  }

  @override
  void dispose() {
    if (_controllerInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    if (_sentenceCount == 0 || !_controllerInitialized) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        itemCount: _sentenceCount * _loopMultiplier,
        onPageChanged: (page) {
          final realIndex = page % _sentenceCount;
          game.sentences.setView(realIndex);
        },
        itemBuilder: (context, pageIndex) {
          final realIndex = pageIndex % _sentenceCount;
          final sentence = sentences[realIndex];

          final bool isUnlocked = game.sentences.isUnlocked(realIndex);
          final bool isActive = game.sentences.viewSentence == realIndex;

          final Color bgColor = isUnlocked
              ? AmagamaColors.secondary
              : AmagamaColors.textSecondary.withValues(alpha: 0.15);

          return AnimatedScale(
            scale: isActive ? 1.0 : 0.88,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 28,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(
                  AmagamaSpacing.radiusLg,
                ),
              ),
              child: Stack(
                children: [
                  // Sentence text
                  Center(
                    child: Text(
                      sentence.text,
                      textAlign: TextAlign.center,
                      style: AmagamaTypography.titleStyle.copyWith(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Padlock for locked sentences
                  if (!isUnlocked)
                    const Positioned(
                      right: 12,
                      top: 12,
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
