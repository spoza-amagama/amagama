// lib/widgets/sentence_audio_widget.dart
import 'package:flutter/material.dart';
import 'package:amagama/services/audio_service.dart';

/// Handles automatic sentence playback when `playOnMatch` toggles true.
class SentenceAudioWidget extends StatefulWidget {
  final String sentenceId;
  final bool playOnMatch;

  const SentenceAudioWidget({
    super.key,
    required this.sentenceId,
    required this.playOnMatch,
  });

  @override
  State<SentenceAudioWidget> createState() => _SentenceAudioWidgetState();
}

class _SentenceAudioWidgetState extends State<SentenceAudioWidget> {
  final AudioService _audio = AudioService();

  @override
  void didUpdateWidget(covariant SentenceAudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.playOnMatch &&
        widget.sentenceId.isNotEmpty &&
        widget.sentenceId != oldWidget.sentenceId) {
      _audio.playSentence(widget.sentenceId);
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
