// 📄 lib/widgets/home/home_content.dart
//
// 🏡 HomeContent — fixed vertical layout (no vertical scroll)
// Ensures PageView gets full width & fixed height for scrolling.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';

import 'grownup_pin_dialog.dart';
import 'home_sentence_carousel.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final idx = game.currentSentenceIndex;
    final sentence = sentences[idx];

    final cyclesDone = game.progress[idx].cyclesCompleted;
    final cyclesTarget = game.cyclesTarget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AmagamaSpacing.md),

        Text(
          'Current Sentence',
          style: AmagamaTypography.titleStyle.copyWith(fontSize: 24),
        ),

        const SizedBox(height: AmagamaSpacing.sm),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AmagamaSpacing.xl,
            vertical: AmagamaSpacing.md,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AmagamaSpacing.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            sentence.text,
            style: AmagamaTypography.bodyStyle.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: AmagamaSpacing.md),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.emoji_events, color: Colors.brown, size: 20),
            SizedBox(width: 4),
            Text('Bronze'),
            SizedBox(width: 16),
            Icon(Icons.emoji_events, color: Colors.grey, size: 20),
            SizedBox(width: 4),
            Text('Silver'),
            SizedBox(width: 16),
            Icon(Icons.emoji_events, color: Colors.amber, size: 20),
            SizedBox(width: 4),
            Text('Gold'),
          ],
        ),

        const SizedBox(height: AmagamaSpacing.xs),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AmagamaSpacing.lg,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: cyclesTarget == 0 ? 0 : cyclesDone / cyclesTarget,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.30),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.green.shade600,
              ),
            ),
          ),
        ),

        const SizedBox(height: AmagamaSpacing.sm),

        Text(
          'Sentence ${idx + 1} of ${sentences.length}',
          style: AmagamaTypography.subtitleStyle,
        ),
        Text(
          'Cycles: $cyclesDone / $cyclesTarget',
          style: AmagamaTypography.subtitleStyle,
        ),

        const SizedBox(height: AmagamaSpacing.md),

        // 🟩 FIX: give the carousel real constraints (width + height)
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            maxWidth: double.infinity,
            minHeight: 120,
            maxHeight: 120,
          ),
          child: const HomeSentenceCarousel(),
        ),

        const SizedBox(height: AmagamaSpacing.sm),

        ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow),
          style: AmagamaButtons.primary,
          label: const Text('Play'),
          onPressed: () => Navigator.pushNamed(context, '/play'),
        ),

        const SizedBox(height: AmagamaSpacing.sm),

        ElevatedButton(
          style: AmagamaButtons.secondary,
          child: const Text('Grown Ups'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const GrownUpPinDialog(),
            );
          },
        ),

        const SizedBox(height: AmagamaSpacing.lg),
      ],
    );
  }
}