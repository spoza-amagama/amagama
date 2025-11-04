import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/game_controller.dart';
import '../../data/index.dart';
import 'home_header.dart';
import 'home_carousel.dart';
import 'reset_dialog.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final s = sentences[game.currentSentenceIndex];
    final isSmall = MediaQuery.of(context).size.height < 720;

    final totalSentences = sentences.length;
    final currentSentence = game.currentSentenceIndex + 1;
    final cyclesTarget = game.cyclesTarget;
    final cyclesDone = game.progress[game.currentSentenceIndex].cyclesCompleted;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🧠 Header section
                Column(
                  children: [
                    HomeHeader(
                      sentence: s.text,
                      isSmall: isSmall,
                      game: game,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Cycles: ${cyclesDone + 1} of $cyclesTarget',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.brown.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sentence $currentSentence of $totalSentences',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.brown.shade600,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: Colors.brown.shade200,
                      thickness: 1,
                      indent: 40,
                      endIndent: 40,
                      height: 16,
                    ),
                  ],
                ),

                // 🪶 Scrollable carousel
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: HomeCarousel(),
                  ),
                ),

                // 🧩 Bottom button area
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                  child: Column(
                    children: [
                      // ▶️ Play button
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/play'),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade500,
                          minimumSize: const Size(160, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 🔁 Grown Ups button only
                      OutlinedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/grownups'),
                        icon: const Icon(Icons.lock_outline),
                        label: const Text('Grown Ups'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.brown.shade800,
                          side: BorderSide(
                            color: Colors.brown.shade400,
                            width: 1.2,
                          ),
                          minimumSize: const Size(160, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
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
