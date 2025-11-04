// lib/widgets/play_audio_manager.dart
import 'package:flutter/material.dart';
import 'package:amagama/services/audio/audio_service.dart';

/// Centralized widget for managing queued audio playback.
/// Ensures word and sentence sounds do not overlap.
class PlayAudioManager extends StatefulWidget {
  final String currentWord;
  final bool shouldPlayWord;
  final String currentSentenceId;
  final bool shouldPlaySentence;

  const PlayAudioManager({
    super.key,
    required this.currentWord,
    required this.shouldPlayWord,
    required this.currentSentenceId,
    required this.shouldPlaySentence,
  });

  @override
  State<PlayAudioManager> createState() => _PlayAudioManagerState();
}

class _PlayAudioManagerState extends State<PlayAudioManager> {
  final AudioService _audio = AudioService();

  @override
  void didUpdateWidget(covariant PlayAudioManager oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🎧 Word audio trigger
    if (widget.shouldPlayWord && widget.currentWord != oldWidget.currentWord) {
      _audio.playWord(widget.currentWord);
    }

    // 🗣️ Sentence audio trigger
    if (widget.shouldPlaySentence &&
        widget.currentSentenceId != oldWidget.currentSentenceId) {
      _audio.playSentence(widget.currentSentenceId);
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
