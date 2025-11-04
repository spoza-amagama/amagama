import 'package:flutter/material.dart';
import 'package:amagama/widgets/play_audio_manager.dart';

/// 🎧 Bridges ValueNotifiers to PlayAudioManager (reactive, isolated)
class AudioStateBridge extends StatelessWidget {
  final ValueNotifier<String> word;
  final ValueNotifier<String> sentenceNotifier;
  final ValueNotifier<bool> playWord;
  final ValueNotifier<bool> playSentence;

  const AudioStateBridge({
    super.key,
    required this.word,
    required this.sentenceNotifier,
    required this.playWord,
    required this.playSentence,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: word,
      builder: (_, w, __) {
        return ValueListenableBuilder<String>(
          valueListenable: sentenceNotifier,
          builder: (_, sid, __) {
            return ValueListenableBuilder<bool>(
              valueListenable: playWord,
              builder: (_, pw, __) {
                return ValueListenableBuilder<bool>(
                  valueListenable: playSentence,
                  builder: (_, ps, __) {
                    return PlayAudioManager(
                      currentWord: w,
                      shouldPlayWord: pw,
                      currentSentenceId: sid,
                      shouldPlaySentence: ps,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
