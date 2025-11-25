// 📄 lib/widgets/game_over/game_over_content.dart
//
// GameOverContent — assembles:
// • GameOverHeader (title + subtitle)
// • GameOverStatsCard (cycles, sentences, trophies)
// • GameOverActions (buttons)
//
// Pulls sentence count + trophies from GameController.
// Totals for completed sentences / cycles are currently placeholders
// until ProgressService exposes summary getters.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';

import 'game_over_header.dart';
import 'game_over_stats_card.dart';
import 'game_over_actions.dart';

class GameOverContent extends StatelessWidget {
  const GameOverContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // Known-safe values from existing APIs
    final totalSentences = game.sentences.total;

    // TODO: Replace these placeholders when ProgressService exposes
    // aggregate stats (e.g. total completed sentences, total cycles).
    const completedSentences = 0;
    const totalCycles = 0;

    final bronze = game.trophies.bronzeTotal;
    final silver = game.trophies.silverTotal;
    final gold = game.trophies.goldTotal;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------------------------
            // Header
            // ---------------------------
            const GameOverHeader(
              title: "Great job!",
              subtitle: "Here’s how you went this round.",
            ),

            const SizedBox(height: 24),

            // ---------------------------
            // Stats card
            // ---------------------------
            GameOverStatsCard(
              totalSentences: totalSentences,
              completedSentences: completedSentences,
              totalCycles: totalCycles,
              bronze: bronze,
              silver: silver,
              gold: gold,
            ),

            const SizedBox(height: 28),

            // ---------------------------
            // Actions
            // ---------------------------
            const GameOverActions(),
          ],
        ),
      ),
    );
  }
}