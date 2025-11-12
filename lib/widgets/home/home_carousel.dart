// 📄 lib/widgets/home/home_carousel.dart
//
// 🧩 HomeCarousel — scrollable list of sentences with lock/tick icons.
// ------------------------------------------------------------
// Current sentence: ✅ green tick
// Future sentences: 🔒 grey padlock
// Past sentences:  ✅ faded green tick

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/game_controller.dart';
import '../../data/index.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final current = game.currentSentenceIndex;

    return ListView.builder(
      itemCount: sentences.length,
      itemBuilder: (context, i) {
        final isUnlocked = i <= current;
        final isCurrent = i == current;

        return AnimatedOpacity(
          opacity: isUnlocked ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 400),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrent
                  ? Colors.green.shade100
                  : Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCurrent
                    ? Colors.green.shade600
                    : Colors.grey.shade400,
                width: isCurrent ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.9),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isUnlocked
                      ? Icons.check_circle
                      : Icons.lock_outline_rounded,
                  color: isUnlocked
                      ? Colors.green.shade700
                      : Colors.grey.shade500,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    sentences[i].text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.w500,
                          color: Colors.brown.shade800,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
