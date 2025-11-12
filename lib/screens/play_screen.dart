// 📄 lib/screens/play_screen.dart
//
// 🎮 Amagama — Play Screen (African-themed, refactored)
// Orchestrates gameplay using Provider GameController and extracted widgets.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/index.dart';
import '../../models/sentence.dart';
import '../../state/game_controller.dart';
import '../../services/audio/audio_service.dart';
import '../../theme/index.dart';

// Widgets
import '../../widgets/home/home_header.dart';
import '../../widgets/play/completion_dialog.dart';
import '../../widgets/play/sentence_progress_section.dart';
import '../../widgets/play/animated_sentence_header.dart';
import '../../widgets/play/game_play_area.dart';
import '../../widgets/play/play_footer.dart';
import '../../widgets/sparkle_layer.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  final AudioService _audio = AudioService();

  // Audio bridge notifiers
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
        sentence: sentence,
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

    // Kick the sentence animation each build if idle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_sentenceAnim.isAnimating && _sentenceAnim.value == 0.0) {
        _sentenceAnim.forward();
      }
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: AmagamaColors.surface,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🟩 Header (matches Home Screen)
            HomeHeader(sentence: s.text, isSmall: false, game: game),

            // 🧾 Themed sentence + subtle progress
            SentenceProgressSection(
              sentenceText: s.text,
              currentSentence: currentSentence,
              totalSentences: totalSentences,
              cyclesDone: cyclesDone,
              cyclesTarget: cyclesTarget,
            ),

            // ✨ Animated sentence header + sparkles
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AmagamaSpacing.md,
                vertical: AmagamaSpacing.xs,
              ),
              child: AnimatedSentenceHeader(
                text: s.text,
                controller: _sentenceAnim,
                sparkleKey: _sentenceSparkleKey,
              ),
            ),

            // 🎲 Gameplay area
            Expanded(
              child: GamePlayArea(
                game: game,
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

            // 🗣️ Footer (message + hidden audio bridge)
            PlayFooter(
              word: _currentWord,
              sentenceNotifier: _currentSentenceId,
              playWord: _playWord,
              playSentence: _playSentence,
            ),
          ],
        ),
      ),
    );
  }
}
