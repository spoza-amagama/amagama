import 'package:audioplayers/audioplayers.dart';

/// Singleton audio playback service for Amagama.
/// Always plays the latest requested sound immediately (no queue).
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _player;
  bool _sentencePlaying = false;

  /// Play a single word (immediate playback)
  Future<void> playWord(String word) async {
    if (_sentencePlaying) return;
    final safe = word.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    await _play('assets/audio/words/$safe.mp3');
  }

  /// Play a sentence (stops current playback first)
  Future<void> playSentence(String id) async {
    _sentencePlaying = true;
    await stop();
    await _play('assets/audio/sentences/s${id.padLeft(2, '0')}.mp3');
    _sentencePlaying = false;
  }

  Future<void> _play(String assetPath) async {
    try {
      // Clean up any active audio
      await stop();

      final player = AudioPlayer();
      _player = player;

      await player.play(
        AssetSource(assetPath.replaceFirst('assets/audio/', 'audio/')),
      );

      player.onPlayerComplete.listen((_) async {
        await player.release();
        await player.dispose();
        if (_player == player) _player = null;
      });
    } catch (e) {
      print('⚠️ Failed to play $assetPath ($e)');
    }
  }

  Future<void> stop() async {
    try {
      if (_player != null) {
        await _player!.stop();
        await _player!.release();
        await _player!.dispose();
        _player = null;
      }
    } catch (_) {}
  }

  // Compatibility helpers
  Future<void> preloadAll() async {}
  Future<void> playTrophyBronze() async =>
      await _play('assets/audio/messages/bronze/bronze_01.mp3');
  Future<void> playTrophySilver() async =>
      await _play('assets/audio/messages/silver/silver_01.mp3');
  Future<void> playTrophyGold() async =>
      await _play('assets/audio/messages/gold/gold_01.mp3');
  Future<void> playFile(String path) async => await _play(path);
  Future<void> dispose() async => await stop();
}
