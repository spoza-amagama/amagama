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
    // 🔈 Play sentence audio automatically when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final game = context.read<GameController>();
      await game.audioService.playSentence(game.currentSentenceIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final s = sentences[game.currentSentenceIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Match the Words — Sentence ${game.currentSentenceIndex + 1}'),
        actions: [
          IconButton(
            tooltip: 'Replay sentence audio',
            icon: const Icon(Icons.volume_up_rounded),
            onPressed: () async {
              await context
                  .read<GameController>()
                  .audioService
                  .playSentence(game.currentSentenceIndex);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              // 👂 Tap the sentence text to replay its audio
              onTap: () async {
                await context
                    .read<GameController>()
                    .audioService
                    .playSentence(game.currentSentenceIndex);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  s.text,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  // 10 round cards in a responsive grid (5x2 on phones)
                  final crossAxisCount = c.maxWidth > 700 ? 5 : 5;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: game.deck.length,
                    itemBuilder: (context, i) {
                      final item = game.deck[i];
                      return RoundCard(
                        item: item,
                        lockInput: game.busy,
                        onTap: () =>
                            context.read<GameController>().flip(item),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
