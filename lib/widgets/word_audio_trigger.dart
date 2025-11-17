import 'package:flutter/material.dart';
import 'package:amagama/services/audio/audio_service.dart';

class WordAudioTrigger extends StatefulWidget {
  final String word;
  final bool play;

  const WordAudioTrigger({
    super.key,
    required this.word,
    required this.play,
  });

  @override
  State<WordAudioTrigger> createState() => _WordAudioTriggerState();
}

class _WordAudioTriggerState extends State<WordAudioTrigger> {
  final _audio = AudioService();

  @override
  void didUpdateWidget(covariant WordAudioTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play &&
        widget.word.isNotEmpty &&
        widget.word != oldWidget.word) {
      final cleanWord = widget.word.split('_').first; // remove timestamp suffix
      _audio.playWord(cleanWord);
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}