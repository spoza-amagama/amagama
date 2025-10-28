// /lib/screens/home_screen.dart
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
    final screen = MediaQuery.of(context).size;
    final isSmall = screen.height < 720 || screen.width < 380;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final content = ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // --- Header ---
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          Image.asset(
                            'assets/logo/amagama_logo.png',
                            width: isSmall ? 80 : 100,
                            height: isSmall ? 80 : 100,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Your Sentence',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmall ? 18 : 20,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Text(
                                s.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isSmall ? 16 : 18,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // 🏆 Trophy chips that wrap automatically
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                _TrophyChip(
                                  label: 'Bronze',
                                  earned: game.currentProg.trophyBronze,
                                  color: const Color(0xFFCD7F32),
                                ),
                                _TrophyChip(
                                  label: 'Silver',
                                  earned: game.currentProg.trophySilver,
                                  color: const Color(0xFFC0C0C0),
                                ),
                                _TrophyChip(
                                  label: 'Gold',
                                  earned: game.currentProg.trophyGold,
                                  color: const Color(0xFFFFD700),
                                ),
                                Text(
                                  '(${game.currentProg.cyclesCompleted}/${game.cyclesTarget})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // --- Sentence Carousel ---
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: SentenceCarousel(
                          count: sentences.length,
                          currentIndex: game.currentSentenceIndex,
                          isUnlocked: game.isSentenceUnlocked,
                          onTap: (i) => game.jumpToSentence(i),
                          sentenceText: (i) => sentences[i].text,
                        ),
                      ),

                      // --- Buttons Section ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.tonalIcon(
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: const Text('Play'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => const PlayScreen()),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.tonalIcon(
                                    icon: const Icon(Icons.assessment_rounded),
                                    label: const Text('Progress'),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const ProgressScreen()),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: FilledButton.tonalIcon(
                                    icon: const Icon(Icons.settings_rounded),
                                    label: const Text('Grown-Ups'),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SettingsScreen()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: content,
              );
            },
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
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: Icon(
        Icons.emoji_events_rounded,
        color: earned ? color : Colors.black26,
        size: 16,
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: earned ? color.withValues(alpha: 0.15) : Colors.black12,
      shape: StadiumBorder(
        side: BorderSide(color: earned ? color : Colors.black26),
      ),
    );
  }
}
