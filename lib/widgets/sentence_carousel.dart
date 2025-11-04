// /lib/widgets/sentence_carousel.dart
import 'package:flutter/material.dart';

class SentenceCarousel extends StatelessWidget {
  final int count;
  final int currentIndex;
  final bool Function(int) isUnlocked;
  final void Function(int) onTap;
  final String Function(int) sentenceText;

  const SentenceCarousel({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.isUnlocked,
    required this.onTap,
    required this.sentenceText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final unlocked = isUnlocked(i);
          final isCurrent = i == currentIndex;
          return InkWell(
            onTap: unlocked ? () => onTap(i) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 240,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: unlocked ? Colors.white : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCurrent
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.black12,
                  width: isCurrent ? 3 : 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                          unlocked
                              ? Icons.lock_open_rounded
                              : Icons.lock_rounded,
                          color: unlocked ? Colors.green : Colors.black54),
                      const SizedBox(width: 8),
                      Text("Sentence ${i + 1}",
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      unlocked
                          ? sentenceText(i)
                          : "Locked — finish your cycles!",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
