import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/index.dart';
import '../data/index.dart';
import '../widgets/index.dart';
import '../screens/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final s = sentences[game.currentSentenceIndex];

    final screenHeight = MediaQuery.of(context).size.height;
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // --- Header ---
        Column(
          children: [
            const SizedBox(height: 8),
            // Logo
            Image.asset(
              'assets/logo/amagama_logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 4),
            Text(
              'Your Sentence',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 6),
            // Sentence card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Text(
                  s.text,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Trophies row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TrophyChip(
                  label: 'Bronze',
                  earned: game.currentProg.trophyBronze,
                  color: const Color(0xFFCD7F32),
                ),
                const SizedBox(width: 4),
                _TrophyChip(
                  label: 'Silver',
                  earned: game.currentProg.trophySilver,
                  color: const Color(0xFFC0C0C0),
                ),
                const SizedBox(width: 4),
                _TrophyChip(
                  label: 'Gold',
                  earned: game.currentProg.trophyGold,
                  color: const Color(0xFFFFD700),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${game.currentProg.cyclesCompleted}/${game.cyclesTarget})',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),

        // --- Sentence carousel ---
        Column(
          children: [
            const SizedBox(height: 6),
            SentenceCarousel(
              count: sentences.length,
              currentIndex: game.currentSentenceIndex,
              isUnlocked: game.isSentenceUnlocked,
              onTap: (i) => game.jumpToSentence(i),
              sentenceText: (i) => sentences[i].text,
            ),
          ],
        ),

        // --- Buttons section ---
        Column(
          children: [
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: const Text('Play'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const PlayScreen()));
              },
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.assessment_rounded, size: 20),
                  label: const Text('Progress'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProgressScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.settings_rounded, size: 20),
                  label: const Text('Grown-Ups'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amagama'),
        backgroundColor: const Color(0xFFFFC107),
        actions: [
          IconButton(
            tooltip: 'Reset Game',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Reset everything?'),
                  content: const Text(
                    'This will erase all progress, trophies, and locks.',
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Reset')),
                  ],
                ),
              );
              if (ok == true) {
                await game.resetAll();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Game reset.')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: screenHeight < 700
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: content,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: content,
                ),
        ),
      ),
    );
  }
}

class _TrophyChip extends StatelessWidget {
  final String label;
  final bool earned;
  final Color color;
  const _TrophyChip({
    required this.label,
    required this.earned,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(
        Icons.emoji_events_rounded,
        color: earned ? color : Colors.black26,
        size: 18,
      ),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      backgroundColor: earned ? color.withOpacity(0.2) : Colors.black12,
      shape: StadiumBorder(
        side: BorderSide(color: earned ? color : Colors.black26),
      ),
    );
  }
}
