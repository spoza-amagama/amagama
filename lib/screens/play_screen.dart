// /lib/screens/play_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/index.dart';
import '../widgets/index.dart';
import '../data/index.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  void initState() {
    super.initState();

    // ▶️ Play sentence audio when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final game = context.read<GameController>();
      final s = sentences[game.currentSentenceIndex];
      game.audioService.playSentence(s.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final s = sentences[game.currentSentenceIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Match the Words — Sentence ${game.currentSentenceIndex + 1}',
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFFFFC107),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          const double spacing = 12.0;
          final totalCards = game.deck.length;

          // 🔢 Find best grid fit (auto size + columns)
          int bestColumns = 2;
          double bestCardSize = 0;

          for (int cols = 2; cols <= totalCards; cols++) {
            final rows = (totalCards / cols).ceil();
            final totalHorizontalSpacing = (cols - 1) * spacing;
            final totalVerticalSpacing = (rows - 1) * spacing + 60; // extra for sentence text
            final cardWidth = (width - totalHorizontalSpacing - 24) / cols;
            final cardHeight = (height - totalVerticalSpacing - 24) / rows;
            final size = cardWidth < cardHeight ? cardWidth : cardHeight;
            if (size > bestCardSize) {
              bestCardSize = size;
              bestColumns = cols;
            }
          }

          final cardSize = bestCardSize;
          final columns = bestColumns;
          final rows = (totalCards / columns).ceil();
          final deck = game.deck;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(spacing),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    s.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final totalWidth = box.maxWidth;
                        final cardWidgets = <Widget>[];

                        // Split deck into rows
                        for (int r = 0; r < rows; r++) {
                          final start = r * columns;
                          final end = (start + columns > totalCards)
                              ? totalCards
                              : start + columns;
                          final rowCards = deck.sublist(start, end);

                          final rowWidth =
                              (rowCards.length * cardSize) +
                                  ((rowCards.length - 1) * spacing);
                          final leftPadding =
                              (totalWidth - rowWidth) / 2; // center incomplete rows

                          cardWidgets.add(
                            Padding(
                              padding: EdgeInsets.only(
                                top: r == 0 ? 0 : spacing,
                                left: leftPadding > 0 ? leftPadding : 0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: rowCards
                                    .map(
                                      (item) => Padding(
                                        padding: EdgeInsets.only(
                                            right: rowCards.last == item
                                                ? 0
                                                : spacing),
                                        child: RoundCard(
                                          item: item,
                                          lockInput: game.busy,
                                          // ✅ FIX: Connect flip logic
                                          onFlip: () async {
                                            await context
                                                .read<GameController>()
                                                .flip(item);
                                          },
                                          size: cardSize,
                                          avatarScale: 0.8,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: cardWidgets,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
