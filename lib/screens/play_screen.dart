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

    // New: sentence index from SentenceService
    final int idx = game.sentences.currentSentence;
    final s = sentences[idx];

    // Sentence id for footer sentence playback
    _sentenceId.value = s.id;

    // Progress for this sentence via ProgressService
    final sentenceProgress = game.progress.bySentenceId(s.id);

    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: GoldConfettiOverlay(
          // Gold confetti driven by TrophyService
          trigger: game.trophies.justUnlockedGold,
          child: Column(
            children: [
              ScreenHeader(
                title: 'Play',
                showLogo: false,
                subtitle: s.text,
                cyclesDone: sentenceProgress.cyclesCompleted,
                cyclesTarget: game.cycles.cyclesTarget,
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
                  // Legacy hook – safe to keep for now; you can no-op it later
                  onComplete: (_) {},
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
