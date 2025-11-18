// 📄 lib/screens/play_screen.dart
// 🎮 Amagama — Play Screen (standard header + gold confetti on gold unlock)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/common/screen_header.dart';
import '../widgets/play/game_play_area.dart';
import '../widgets/play/play_footer.dart';
import '../widgets/common/gold_confetti_overlay.dart';

import '../data/index.dart';
import '../state/game_controller.dart';
import '../services/audio/audio_service.dart';
import '../theme/index.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with TickerProviderStateMixin {
  final AudioService _audio = AudioService();

  final ValueNotifier<String> _currentWord = ValueNotifier('');
  final ValueNotifier<String> _sentenceId = ValueNotifier('');
  final ValueNotifier<bool> _playWord = ValueNotifier(false);
  final ValueNotifier<bool> _playSentence = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final idx = game.currentSentenceIndex;
    final s = sentences[idx];

    _sentenceId.value = idx.toString();

    // 🪄 Confetti is handled via GameController.justUnlockedGold
    // GameController will call consumeGoldConfetti() after PlayScreen rebuilds.

    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: GoldConfettiOverlay(
          trigger: game.justUnlockedGold,
          child: Column(
            children: [
              ScreenHeader(
                title: 'Play',
                showLogo: false,
                subtitle: s.text,
                cyclesDone: game.progress[idx].cyclesCompleted,
                cyclesTarget: game.cyclesTarget,
                sentenceNumber: idx + 1,
                totalSentences: sentences.length,
                leadingAction: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Expanded(
                child: GamePlayArea(
                  game: game,
                  audioService: _audio,
                  onWord: (w) {
                    _currentWord.value = w;
                    _playWord.value = true;
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _playWord.value = false,
                    );
                  },
                  // Legacy hook: still passed, but GameController no-ops it
                  onComplete: (_) => game.finishSentence(context),
                ),
              ),

              PlayFooter(
                word: _currentWord,
                sentenceNotifier: _sentenceId,
                playWord: _playWord,
                playSentence: _playSentence,
              ),
            ],
          ),
        ),
      ),
    );
  }
}