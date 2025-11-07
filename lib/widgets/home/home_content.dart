import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/game_controller.dart';
import '../../data/index.dart';
import 'home_header.dart';
import 'home_carousel.dart';
import 'grownup_pin_dialog.dart'; // ✅ PIN dialog

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
                // 🧠 Header + info
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
                    const SizedBox(height: 4),
                    Text(
                      'Sentence $currentSentence of $totalSentences',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.brown.shade600,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      color: Colors.brown.shade200,
                      thickness: 1,
                      indent: 40,
                      endIndent: 40,
                      height: 12,
                    ),
                  ],
                ),

                // 🪶 Expanded carousel — takes more height now
                const Expanded(
                  flex: 6, // increased from 4 → 6
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: ClipRect(
                      child: HomeCarousel(),
                    ),
                  ),
                ),

                // 🧩 Compact bottom buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                  child: Column(
                    children: [
                      // ▶️ Play button (smaller)
                      ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/play'),
                        icon: const Icon(Icons.play_arrow, size: 22),
                        label: const Text('Play'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade500,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          minimumSize: const Size(130, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 🔒 Grown Ups button (smaller)
                      OutlinedButton.icon(
                        onPressed: () async {
                          final allowed = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const GrownUpPinDialog(),
                              ) ??
                              false;

                          if (allowed) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, '/grownups');
                          }
                        },
                        icon: const Icon(Icons.lock, size: 20),
                        label: const Text('Grown Ups'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.brown.shade800,
                          side: BorderSide(
                              color: Colors.brown.shade400, width: 1.1),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                          minimumSize: const Size(130, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
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
