// 📄 lib/screens/play_screen.dart
//
// 🎮 Amagama — Play Screen
// ------------------------------------------------------------
// Unified Play Screen that mirrors the Home Screen header and manages gameplay
// for one sentence. Displays the current sentence, progress indicators, cycle
// progress bar, sparkle animations, matching grid, and completion dialog.
// Integrates with GameController and AudioService for state + sound.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/data/index.dart';
import 'package:amagama/models/sentence.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/services/audio/audio_service.dart';

// 🧩 Widgets (direct imports only — no barrels, no aliases)
import 'package:amagama/widgets/home/home_header.dart';
import 'package:amagama/widgets/play/play_body.dart';
import 'package:amagama/widgets/play/completion_dialog.dart';
import 'package:amagama/widgets/play/cycle_progress_bar.dart';
import 'package:amagama/widgets/play/sentence_stack.dart';
import 'package:amagama/widgets/play/progress_message.dart';
import 'package:amagama/widgets/play/audio_state_bridge.dart';
import 'package:amagama/widgets/sparkle_layer.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  final AudioService _audio = AudioService();

  final ValueNotifier<String> _currentWord = ValueNotifier<String>('');
  final ValueNotifier<String> _currentSentenceId = ValueNotifier<String>('');
  final ValueNotifier<bool> _playWord = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _playSentence = ValueNotifier<bool>(false);

  late final AnimationController _sentenceAnim;
  final GlobalKey<SparkleLayerState> _sentenceSparkleKey =
      GlobalKey<SparkleLayerState>();

  @override
  void initState() {
    super.initState();
    _sentenceAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
  }

  @override
  void dispose() {
    _sentenceAnim.dispose();
    _currentWord.dispose();
    _currentSentenceId.dispose();
    _playWord.dispose();
    _playSentence.dispose();
    super.dispose();
  }

  void _queuePlayWord(String word) {
    _currentWord.value = word;
    _playWord.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playWord.value = false;
    });
  }

  Future<void> _showCompletionDialog({
    required int sentenceIndex,
    required Sentence sentence,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CompletionDialog(
        sentenceIndex: sentenceIndex,
        sentence: sentence, // ✅ Sentence type
        onNext: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    final int idx = game.currentSentenceIndex;
    final Sentence s = sentences[idx];
    final int totalSentences = sentences.length;
    final int currentSentence = idx + 1;
    final int cyclesTarget = game.cyclesTarget;
    final int cyclesDone = game.progress[idx].cyclesCompleted;

    _currentSentenceId.value = idx.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_sentenceAnim.isAnimating && _sentenceAnim.value == 0.0) {
        _sentenceAnim.forward();
      }
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🟩 Header (matches Home Screen)
            HomeHeader(sentence: s.text, isSmall: false, game: game),

            // 🧾 Sentence + subtle progress
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    s.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sentence $currentSentence of $totalSentences',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Cycle ${cyclesDone + 1} of $cyclesTarget',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                  ),
                  const SizedBox(height: 10),
                  const CycleProgressBar(),
                ],
              ),
            ),

            // ✨ Animated sentence header + sparkles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SentenceStack(
                text: s.text,
                controller: _sentenceAnim,
                sparkleKey: _sentenceSparkleKey,
              ),
            ),

            // 🎲 Gameplay area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: PlayBody(
                  game: game, // ✅ Required param
                  fadeOut: true,
                  audioService: _audio,
                  onWord: (word) => _queuePlayWord(word),
                  onComplete: (_) async {
                    await _showCompletionDialog(
                      sentenceIndex: idx,
                      sentence: s,
                    );
                  },
                ),
              ),
            ),

            // 🗣️ Friendly progress message footer
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: ProgressMessage(),
            ),

            // 🎧 Hidden audio bridge
            SizedBox(
              height: 0,
              width: 0,
              child: AudioStateBridge(
                word: _currentWord,
                sentenceNotifier: _currentSentenceId,
                playWord: _playWord,
                playSentence: _playSentence,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
