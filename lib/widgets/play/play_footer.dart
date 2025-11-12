// 📄 lib/widgets/play/play_footer.dart
//
// Footer with friendly ProgressMessage and hidden AudioStateBridge wiring.

import 'package:flutter/material.dart';
import '../../../theme/index.dart';
import 'progress_message.dart';
import 'audio_state_bridge.dart';

class PlayFooter extends StatelessWidget {
  final ValueNotifier<String> word;
  final ValueNotifier<String> sentenceNotifier;
  final ValueNotifier<bool> playWord;
  final ValueNotifier<bool> playSentence;

  const PlayFooter({
    super.key,
    required this.word,
    required this.sentenceNotifier,
    required this.playWord,
    required this.playSentence,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AmagamaSpacing.lg,
        top: AmagamaSpacing.sm,
      ),
      child: Column(
        children: [
          const ProgressMessage(),
          const SizedBox(height: AmagamaSpacing.sm),
          SizedBox(
            height: 0,
            width: 0,
            child: AudioStateBridge(
              word: word,
              sentenceNotifier: sentenceNotifier,
              playWord: playWord,
              playSentence: playSentence,
            ),
          ),
        ],
      ),
    );
  }
}
