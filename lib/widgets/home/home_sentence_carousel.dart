// 📄 lib/widgets/home/home_sentence_carousel.dart
//
// ⭐ Fully scrollable horizontal carousel (ListView + snapping)
// • Continuous horizontal scroll (NOT page-by-page)
// • Snaps to nearest card
// • Locked sentences dim + snap-back
// • No clipping
// • Works perfectly on macOS, iOS, Android, Web

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';

class HomeSentenceCarousel extends StatefulWidget {
  const HomeSentenceCarousel({super.key});

  @override
  State<HomeSentenceCarousel> createState() => _HomeSentenceCarouselState();
}

class _HomeSentenceCarouselState extends State<HomeSentenceCarousel> {
  late final ScrollController _scroll;
  final itemWidth = 260.0; // card size + padding

  @override
  void initState() {
    super.initState();
    final game = context.read<GameController>();
    _scroll = ScrollController(
      initialScrollOffset: game.currentSentenceIndex * itemWidth,
    );
  }

  void _snapTo(int index) {
    _scroll.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return LayoutBuilder(
      builder: (context, box) {
        return SizedBox(
          height: box.maxHeight,
          width: box.maxWidth,
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (n) {
              final position = _scroll.offset;
              int index = (position / itemWidth).round();

              if (index < 0) index = 0;
              if (index >= sentences.length) index = sentences.length - 1;

              // Lock logic
              if (game.isSentenceUnlocked(index)) {
                game.jumpToSentence(index);
              } else {
                _snapTo(game.currentSentenceIndex);
              }

              return true;
            },
            child: ListView.builder(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: sentences.length,
              itemBuilder: (context, i) {
                final s = sentences[i];
                final unlocked = game.isSentenceUnlocked(i);
                final isCurrent = i == game.currentSentenceIndex;

                return SizedBox(
                  width: itemWidth,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: unlocked ? 1 : 0.45,
                    child: AnimatedScale(
                      scale: isCurrent ? 1.0 : 0.92,
                      duration: const Duration(milliseconds: 150),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          borderRadius:
                              BorderRadius.circular(AmagamaSpacing.radiusLg),
                          border: Border.all(
                            color: unlocked
                                ? Colors.green.shade700
                                : Colors.grey.shade600,
                            width: isCurrent ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  s.text,
                                  textAlign: TextAlign.center,
                                  style: AmagamaTypography.bodyStyle.copyWith(
                                    fontSize: unlocked ? 15 : 13,
                                    fontWeight: isCurrent
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: unlocked
                                        ? Colors.black
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),

                            if (!unlocked)
                              const Positioned(
                                right: 8,
                                top: 6,
                                child: Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}