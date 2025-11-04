// ignore_for_file: avoid_print
import 'dart:io';

/// 🛠️ Amagama Screen Patch Script
/// ------------------------------------------------------------
/// Automatically replaces the main screen files with clean,
/// production-ready versions compatible with the new
/// single-function GameController architecture.
///
/// Patches:
///  • lib/screens/play_screen.dart
///  • lib/screens/progress_screen.dart
///  • lib/screens/settings_screen.dart
///  • lib/widgets/home/home_carousel.dart
///
/// Run with:
///   dart run tool/patch_all_screens.dart
///
void main() async {
  print('🚀 Starting Amagama screen patcher...');

  await _patchPlayScreen();
  await _patchProgressScreen();
  await _patchSettingsScreen();
  await _patchHomeCarousel();

  print('\n✅ All target screens successfully patched.');
  print('👉 Run: flutter clean && flutter pub get && flutter analyze && flutter run');
}

// ---------------------------------------------------------------------------
//  PATCH: PlayScreen
// ---------------------------------------------------------------------------
Future<void> _patchPlayScreen() async {
  const path = 'lib/screens/play_screen.dart';
  final file = File(path);
  if (!await file.exists()) return;

  const content = '''
// 📄 lib/screens/play_screen.dart
//
// 🎮 PlayScreen
// ------------------------------------------------------------
// Main interactive screen for matching cards in each sentence.
//
// RESPONSIBILITIES
// • Displays the current sentence and learning cycle progress.
// • Hosts the AnimatedMatchGrid for matching gameplay.
// • Handles taps via GameController.onCardTapped().
// • Uses Provider for live game state updates.
//
// DEPENDENCIES
// • [GameController], [AnimatedMatchGrid], [CycleProgressBar],
//   [SentenceUnlockIndicator], [ProgressMessage].
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/widgets/play/index.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final sentenceId = game.currentSentenceIndex;
    final sentence = sentences[sentenceId];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sentence \${sentenceId + 1}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SentenceUnlockIndicator(index: sentenceId),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Text(
                sentence.text,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const CycleProgressBar(),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedMatchGrid(
                  cards: game.deck,
                  onCardTap: (card) => game.onCardTapped(card),
                ),
              ),
              const SizedBox(height: 12),
              const ProgressMessage(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
''';

  await file.writeAsString(content);
  print('✅ Patched $path');
}

// ---------------------------------------------------------------------------
//  PATCH: ProgressScreen
// ---------------------------------------------------------------------------
Future<void> _patchProgressScreen() async {
  const path = 'lib/screens/progress_screen.dart';
  final file = File(path);
  if (!await file.exists()) return;

  const content = '''
// 📄 lib/screens/progress_screen.dart
//
// 🏆 ProgressScreen
// ------------------------------------------------------------
// Displays overall learning progress across all sentences.
//
// RESPONSIBILITIES
// • Shows per-sentence progress bars and trophy icons.
// • Reflects real-time data from [GameController.progress].
// • Indicates whether each sentence is unlocked.
// • Provides a clean scrollable layout.
//
// DEPENDENCIES
// • [GameController] via Provider.
// • [sentences] list from data/index.dart.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_controller.dart';
import '../data/index.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final total = sentences.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: total,
        itemBuilder: (context, i) {
          if (i >= game.progress.length) return const SizedBox.shrink();

          final p = game.progress[i];
          final ratio =
              game.cyclesTarget > 0 ? p.cyclesCompleted / game.cyclesTarget : 0.0;
          final bool unlocked = i <= game.currentSentenceIndex;
          final color = unlocked ? Colors.green : Colors.grey.shade400;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Sentence \${i + 1}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      if (p.trophyGold)
                        const Icon(Icons.emoji_events_rounded,
                            color: Color(0xFFFFD700))
                      else if (p.trophySilver)
                        const Icon(Icons.emoji_events_rounded,
                            color: Color(0xFFC0C0C0))
                      else if (p.trophyBronze)
                        const Icon(Icons.emoji_events_rounded,
                            color: Color(0xFFCD7F32))
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sentences[i].text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: ratio.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\${p.cyclesCompleted}/\${game.cyclesTarget} cycles completed',
                    style: Theme.of(context).textTheme.labelLarge,
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
''';

  await file.writeAsString(content);
  print('✅ Patched $path');
}

// ---------------------------------------------------------------------------
//  PATCH: SettingsScreen
// ---------------------------------------------------------------------------
Future<void> _patchSettingsScreen() async {
  const path = 'lib/screens/settings_screen.dart';
  final file = File(path);
  if (!await file.exists()) return;

  const content = '''
// 📄 lib/screens/settings_screen.dart
//
// ⚙️ SettingsScreen
// ------------------------------------------------------------
// Manages app configuration and game reset.
//
// RESPONSIBILITIES
// • Adjusts cycle targets.
// • Resets all saved progress.
// • Reloads the GameController after changes.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cycles per sentence',
                style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: game.cyclesTarget.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              label: '\${game.cyclesTarget}',
              onChanged: (v) async {
                // Reload game with new cycle target
                game.setCyclesTarget(v.toInt());
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset All Progress'),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset All Progress?'),
                    content: const Text(
                        'This will erase your trophies and sentence progress.'),
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
                if (confirm == true) await game.resetAll();
              },
            ),
          ],
        ),
      ),
    );
  }
}
''';

  await file.writeAsString(content);
  print('✅ Patched $path');
}

// ---------------------------------------------------------------------------
//  PATCH: HomeCarousel
// ---------------------------------------------------------------------------
Future<void> _patchHomeCarousel() async {
  const path = 'lib/widgets/home/home_carousel.dart';
  final file = File(path);
  if (!await file.exists()) return;

  const content = '''
// 📄 lib/widgets/home/home_carousel.dart
//
// 🏠 HomeCarousel
// ------------------------------------------------------------
// Displays sentence preview cards on the home screen.
//
// RESPONSIBILITIES
// • Shows which sentences are unlocked.
// • Allows navigation to unlocked sentences only.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      itemCount: sentences.length,
      itemBuilder: (context, i) {
        final unlocked = i <= game.currentSentenceIndex;

        return GestureDetector(
          onTap: unlocked ? () async => await game.jumpToSentence(i) : null,
          child: Container(
            width: 180,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: unlocked ? Colors.white : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  sentences[i].text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            unlocked ? Colors.black87 : Colors.grey.shade600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
''';

  await file.writeAsString(content);
  print('✅ Patched $path');
}
