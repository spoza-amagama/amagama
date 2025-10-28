import 'package:flutter/material.dart';
import 'package:amagama/services/audio_service.dart';

class PlayAudioManagerController extends ChangeNotifier {
  final AudioService _audio = AudioService();

  Future<void> playWord(String word) async {
    await _audio.playWord(word);
  }

  Future<void> playSentence(String sentenceId) async {
    try {
      final id = int.parse(sentenceId);
      await _audio.playSentence(id);
    } catch (_) {}
  }

  Future<void> disposeManager() async {
    await _audio.dispose();
  }
}

class PlayAudioManager extends StatefulWidget {
  const PlayAudioManager({super.key});

  @override
  State<PlayAudioManager> createState() => _PlayAudioManagerState();
}

class _PlayAudioManagerState extends State<PlayAudioManager> {
  @override
  Widget build(BuildContext context) {
    // invisible widget — audio only
    return const SizedBox.shrink();
  }
}
