// 📄 lib/screens/play_screen.dart
// 🎮 Amagama — Play Screen (standard header + gold confetti on gold unlock)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/common/index.dart';
import '../widgets/play/game_play_area.dart';
import '../widgets/play/play_footer.dart';

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
    final sentence = game.sentences.byIndex(idx);

    // Sentence id for footer sentence playback (ensure String)
    _sentenceId.value = sentence.id.toString();

    // Corrected: Progress lookup now uses int
    final sentenceProgress = game.progress.bySentenceId(sentence.id);

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
                subtitle: sentence.text,
                cyclesDone: sentenceProgress.cyclesCompleted,
                cyclesTarget: game.cycles.cyclesTarget,
                sentenceNumber: idx + 1,
                totalSentences: game.sentences.total,
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