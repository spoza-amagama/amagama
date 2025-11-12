// 📄 lib/screens/play_screen.dart
//
// African-themed PlayScreen for Amagama.
// Coordinates gameplay logic and uses themed widgets for consistent style.

import 'package:flutter/material.dart';
import '../../state/game_controller.dart';
import '../../services/audio/audio_service.dart';
import '../../widgets/play/index.dart';
import '../../theme/index.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late final GameController controller;
  late final AudioService audio;
  late final AnimationController sparkleController;

  @override
  void initState() {
    super.initState();
    controller = GameController();
    audio = AudioService();
    sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    sparkleController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AmagamaColors.surface,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AmagamaColors.background,
                AmagamaColors.surface.withValues(alpha: 0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Sentence + progress
              ValueListenableBuilder(
                valueListenable: controller.progress,
                builder: (context, progress, _) => SentenceProgressSection(
                  sentenceText: controller.currentSentence.text,
                  currentSentence: controller.currentSentenceIndex + 1,
                  totalSentences: controller.totalSentences,
                  cyclesDone: controller.cycleCount,
                  cyclesTarget: controller.totalCycles,
                ),
              ),
              const SizedBox(height: AmagamaSpacing.sm),

              // Animated sentence header
              AnimatedSentenceHeader(
                sparkleController: sparkleController,
                sentence: controller.currentSentence.text,
              ),

              // Main play area
              Expanded(
                child: GamePlayArea(
                  controller: controller,
                  onWord: (word) => audio.playWord(word),
                  onComplete: () {
                    controller.completeSentence();
                    sparkleController.forward(from: 0);
                  },
                ),
              ),

              // Footer
              PlayFooter(
                controller: controller,
                audio: audio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
