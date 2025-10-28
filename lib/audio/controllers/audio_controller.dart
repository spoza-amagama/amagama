import 'package:just_audio/just_audio.dart';

class AudioController {
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  final _player = AudioPlayer();

  Future<void> playWord(String word) async {
    final path = 'assets/audio/words/$word.mp3';
    await _play(path);
  }

  Future<void> playSentence(String sentenceId) async {
    final path = 'assets/audio/sentence/$sentenceId.mp3';
    await _play(path);
  }

  Future<void> _play(String assetPath) async {
    try {
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      print('Audio play error: $e');
    }
  }

  void dispose() => _player.dispose();
}
