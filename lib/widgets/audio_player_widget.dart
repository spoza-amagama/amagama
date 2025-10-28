// 📁 lib/widgets/audio_player_widget.dart
import 'package:flutter/material.dart';
import 'package:amagama/services/index.dart';




class AudioPlayerWidget extends StatefulWidget {
  final String word;
  final String sentenceId;
  final bool playWord;
  final bool playSentence;

  const AudioPlayerWidget({
    super.key,
    required this.word,
    required this.sentenceId,
    required this.playWord,
    required this.playSentence,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioService _audio = AudioService();

  String? _lastPlayedWord;
  String? _lastPlayedSentence;
  bool _isPlaying = false;

  @override
  void didUpdateWidget(AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🟢 If a new sentence should play
    if (widget.playSentence &&
        widget.sentenceId.isNotEmpty &&
        widget.sentenceId != _lastPlayedSentence) {
      _playSentence(widget.sentenceId);
      return;
    }

    // 🟡 If a new word should play
    if (widget.playWord &&
        widget.word.isNotEmpty &&
        widget.word != _lastPlayedWord) {
      _playWord(widget.word);
    }
  }

  Future<void> _stopCurrentAudio() async {
    try {
      await _audio.stop();
    } catch (_) {}
    _isPlaying = false;
  }

  Future<void> _playWord(String word) async {
    if (_isPlaying) await _stopCurrentAudio();

    final file = 'audio/words/$word.mp3';
    try {
      _isPlaying = true;
      _lastPlayedWord = word;
      await _audio.playFile(file);
    } catch (e) {
      debugPrint('⚠️ Word audio failed: $e');
    } finally {
      _isPlaying = false;
    }
  }

  Future<void> _playSentence(String id) async {
    if (_isPlaying) await _stopCurrentAudio();

    final int? sid = int.tryParse(id);
    if (sid == null) return;

    final file = 'audio/sentence/$sid.mp3';
    try {
      _isPlaying = true;
      _lastPlayedSentence = id;
      await _audio.playFile(file);
    } catch (e) {
      debugPrint('⚠️ Sentence audio failed: $e');
    } finally {
      _isPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
