import 'package:flutter/material.dart';
import '../controllers/audio_controller.dart';

class WordAudioWidget extends StatefulWidget {
  final String word;
  final bool shouldPlay;

  const WordAudioWidget({
    super.key,
    required this.word,
    required this.shouldPlay,
  });

  @override
  State<WordAudioWidget> createState() => _WordAudioWidgetState();
}

class _WordAudioWidgetState extends State<WordAudioWidget> {
  final _audio = AudioController();

  @override
  void didUpdateWidget(covariant WordAudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldPlay && widget.word != oldWidget.word) {
      _audio.playWord(widget.word.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
