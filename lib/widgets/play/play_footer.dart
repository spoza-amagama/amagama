// 📄 lib/widgets/play/play_footer.dart
//
// 🎚 PlayFooter — shows the current word + audio controls for
// "Hear word" and "Hear sentence". Uses [AudioTrigger] to
// actually play queued audio.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/audio_trigger.dart';

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

  void _trigger(ValueNotifier<bool> flag) {
    flag.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      flag.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AmagamaColors.surface.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: AmagamaColors.overlay(0.12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current word label
          ValueListenableBuilder<String>(
            valueListenable: word,
            builder: (_, value, __) {
              final text = value.isEmpty ? 'Tap a card to hear a word' : value;
              return Text(
                text,
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: 18,
                  color: AmagamaColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  onPressed: () {
                    if (word.value.isEmpty) return;
                    _trigger(playWord);
                  },
                  label: const Text('Hear word'),
                  style: AmagamaButtons.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.record_voice_over_rounded, size: 20),
                  onPressed: () {
                    if (sentenceNotifier.value.isEmpty) return;
                    _trigger(playSentence);
                  },
                  label: const Text('Hear sentence'),
                  style: AmagamaButtons.secondary,
                ),
              ),
            ],
          ),

          // Hidden audio triggers
          ValueListenableBuilder<bool>(
            valueListenable: playWord,
            builder: (_, shouldPlay, __) => AudioTrigger(
              type: 'word',
              id: word.value,
              play: shouldPlay,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: playSentence,
            builder: (_, shouldPlay, __) => AudioTrigger(
              type: 'sentence',
              id: sentenceNotifier.value,
              play: shouldPlay,
            ),
          ),
        ],
      ),
    );
  }
}