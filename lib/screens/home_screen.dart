import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/index.dart';
import '../data/index.dart';
import '../widgets/index.dart';
import '../screens/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    // Delay slightly for a smoother entrance
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final s = sentences[game.currentSentenceIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amagama'),
        actions: [
          IconButton(
            tooltip: 'Reset Game',
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
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Reset'),
                    ),
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
            icon: const Icon(Icons.refresh_rounded),
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🐘 Animated logo
              Center(
                child: FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Image.asset(
                      'assets/logo/amagama_logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your Sentence',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    s.text,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _TrophyChip(
                    label: 'Bronze',
                    earned: game.currentProg.trophyBronze,
                    color: const Color(0xFFCD7F32),
                  ),
                  const SizedBox(width: 8),
                  _TrophyChip(
                    label: 'Silver',
                    earned: game.currentProg.trophySilver,
                    color: const Color(0xFFC0C0C0),
                  ),
                  const SizedBox(width: 8),
                  _TrophyChip(
                    label: 'Gold',
                    earned: game.currentProg.trophyGold,
                    color: const Color(0xFFFFD700),
                  ),
                  const Spacer(),
                  Text(
                    'Cycles: ${game.currentProg.cyclesCompleted}/${game.cyclesTarget}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SentenceCarousel(
                count: sentences.length,
                currentIndex: game.currentSentenceIndex,
                isUnlocked: game.isSentenceUnlocked,
                onTap: (i) => game.jumpToSentence(i),
                sentenceText: (i) => sentences[i].text,
              ),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Play'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PlayScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.assessment_rounded),
                    label: const Text('Progress'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProgressScreen()),
                      );
                    },
                  ),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.settings_rounded),
                    label: const Text('Grown-Ups'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
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
      avatar: Icon(
        Icons.emoji_events_rounded,
        color: earned ? color : Colors.black26,
      ),
      label: Text(label),
      backgroundColor: earned ? color.withOpacity(0.2) : Colors.black12,
      shape: StadiumBorder(
        side: BorderSide(color: earned ? color : Colors.black26),
      ),
    );
  }
}
