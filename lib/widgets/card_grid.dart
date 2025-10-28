import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/index.dart';
import 'package:amagama/widgets/index.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/services/audio_service.dart'; // ✅ audio engine

class CardGrid extends StatefulWidget {
  final void Function(String word)? onWordFlip; // ✅ callbacks
  final void Function(String sentenceId)? onSentenceComplete;

  const CardGrid({
    super.key,
    this.onWordFlip,
    this.onSentenceComplete,
  });

  @override
  State<CardGrid> createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  int? _glowingCardId;
  final Set<int> _matchedCardIds = {};
  late final AudioService _audio; // ✅ shared service

  @override
  void initState() {
    super.initState();
    _audio = AudioService();
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final sentence = sentences[game.currentSentenceIndex];

    return LayoutBuilder(
      builder: (context, box) {
        final totalWidth = box.maxWidth;
        final totalHeight = box.maxHeight;
        final deck = game.deck;
        final totalCards = deck.length;
        final baseSpacing =
            totalWidth < 400 ? 8 : totalWidth < 600 ? 10 : 14;

        // 🔢 calculate grid
        int bestCols = 2;
        int bestRows = (totalCards / bestCols).ceil();
        double bestCardSize = 0;
        for (int cols = 2; cols <= totalCards; cols++) {
          final rows = (totalCards / cols).ceil();
          final totalHSpacing = (cols - 1) * baseSpacing;
          final totalVSpacing = (rows - 1) * baseSpacing;
          final availableWidth = totalWidth - totalHSpacing - 16;
          final availableHeight = totalHeight - totalVSpacing - 16;
          if (availableWidth <= 0 || availableHeight <= 0) continue;
          final maxCardWidth = availableWidth / cols;
          final maxCardHeight = availableHeight / rows;
          final size =
              maxCardWidth < maxCardHeight ? maxCardWidth : maxCardHeight;
          if (cols * rows >= totalCards && size > bestCardSize) {
            bestCardSize = size;
            bestCols = cols;
            bestRows = rows;
          }
        }

        final cardSize = bestCardSize.clamp(40.0, 180.0);
        final usedHeight =
            bestRows * cardSize + (bestRows - 1) * baseSpacing;
        final topPadding =
            ((totalHeight - usedHeight) / 2).clamp(0.0, double.infinity);

        return Padding(
          padding: EdgeInsets.only(top: topPadding, left: 8, right: 8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: deck.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: bestCols,
              crossAxisSpacing: baseSpacing.toDouble(),
              mainAxisSpacing: baseSpacing.toDouble(),
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = deck[index];
              List<BoxShadow> shadows = [];

              if (_matchedCardIds.contains(item.id)) {
                shadows = [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.7),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ];
              } else if (_glowingCardId == item.id) {
                shadows = [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.7),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ];
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(boxShadow: shadows),
                child: Center(
                  child: RoundCard(
                    item: item,
                    lockInput: game.busy,
                    onFlip: () async {
                      final beforeMatched = game.deck
                          .where((c) => c.isMatched)
                          .map((c) => c.id)
                          .toSet();

                      await context.read<GameController>().flip(item);
                      final allNowMatched =
                          game.deck.every((c) => c.isMatched);

                      // 🎧 Play word immediately if not final match
                      if (!item.isMatched &&
                          item.isFaceUp &&
                          !allNowMatched) {
                        widget.onWordFlip?.call(item.word);
                        await _audio.playWord(item.word);
                        setState(() => _glowingCardId = item.id);
                        Future.delayed(const Duration(milliseconds: 800), () {
                          if (mounted) setState(() => _glowingCardId = null);
                        });
                      }

                      // 🟩 Flash for matched pairs
                      final afterMatched = game.deck
                          .where((c) => c.isMatched)
                          .map((c) => c.id)
                          .toSet();
                      final newMatches =
                          afterMatched.difference(beforeMatched);
                      if (newMatches.isNotEmpty) {
                        setState(() => _matchedCardIds.addAll(newMatches));
                        Future.delayed(const Duration(milliseconds: 600), () {
                          if (mounted) {
                            setState(
                                () => _matchedCardIds.removeAll(newMatches));
                          }
                        });
                      }

                      // 🗣️ Play sentence after all matched
                      if (allNowMatched) {
                        await Future.delayed(
                            const Duration(milliseconds: 300));
                        widget.onSentenceComplete
                            ?.call(sentence.id.toString());
                        await _audio.playSentence(sentence.id.toString());
                      }
                    },
                    size: cardSize,
                    avatarScale: 0.8,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
