// 📄 file: lib/widgets/audio_trigger.dart
// A unified, reusable widget that triggers queued audio playback
// for both words and sentences using AudioService.

import 'package:flutter/material.dart';
import 'package:amagama/services/audio/audio_service.dart';

class AudioTrigger extends StatefulWidget {
  /// The type of audio to play: 'word' or 'sentence'
  final String type;

  /// The identifier for the audio (word text or sentence ID)
  final String id;

  /// Whether playback should be triggered
  final bool play;

  const AudioTrigger({
    super.key,
    required this.type,
    required this.id,
    required this.play,
  });

  @override
  State<AudioTrigger> createState() => _AudioTriggerState();
}

class _AudioTriggerState extends State<AudioTrigger> {
  final AudioService _audio = AudioService();

  @override
  void didUpdateWidget(covariant AudioTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.play && widget.id.isNotEmpty && widget.id != oldWidget.id) {
      _playAudio(widget.type, widget.id);
    }
  }

  Future<void> _playAudio(String type, String id) async {
    try {
      if (type == 'word') {
        await _audio.playWord(id);
      } else if (type == 'sentence') {
        // Sentence IDs are strings but map cleanly to numeric audio files
        final index = int.tryParse(id) ?? 1;
        await _audio.playSentence(index);
      }
    } catch (e) {
      debugPrint('⚠️ AudioTrigger failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}