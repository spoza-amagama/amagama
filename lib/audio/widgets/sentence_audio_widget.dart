import 'package:flutter/material.dart';
import '../controllers/audio_controller.dart';

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
  final _audio = AudioController();

  @override
  void didUpdateWidget(covariant SentenceAudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playOnMatch && widget.sentenceId != oldWidget.sentenceId) {
      _audio.playSentence(widget.sentenceId.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
