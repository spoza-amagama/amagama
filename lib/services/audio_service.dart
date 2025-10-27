import 'package:audioplayers/audioplayers.dart';

/// Handles all offline audio playback for Amagama.
/// Works with audioplayers ^6.5.x (modern API)
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final AudioCache _cache = AudioCache(prefix: 'assets/audio/');

  AudioService();

  /// Preload frequently used assets for faster playback
  Future<void> preloadAll() async {
    try {
      await _cache.loadAll([
        // Regular messages
        'messages/regular/01.mp3',
        'messages/regular/02.mp3',
        'messages/regular/03.mp3',
        'messages/regular/04.mp3',
        'messages/regular/05.mp3',
        'messages/regular/06.mp3',
        'messages/regular/07.mp3',
        'messages/regular/08.mp3',
        'messages/regular/09.mp3',
        'messages/regular/10.mp3',
        'messages/regular/11.mp3',
        'messages/regular/12.mp3',
        'messages/regular/13.mp3',
        'messages/regular/14.mp3',
        'messages/regular/15.mp3',
        'messages/regular/16.mp3',
        'messages/regular/17.mp3',
        'messages/regular/18.mp3',
        'messages/regular/19.mp3',
        // Bronze / Silver / Gold
        'messages/bronze/bronze_01.mp3',
        'messages/bronze/bronze_02.mp3',
        'messages/bronze/bronze_03.mp3',
        'messages/bronze/bronze_04.mp3',
        'messages/bronze/bronze_05.mp3',
        'messages/silver/silver_01.mp3',
        'messages/silver/silver_02.mp3',
        'messages/silver/silver_03.mp3',
        'messages/silver/silver_04.mp3',
        'messages/silver/silver_05.mp3',
        'messages/gold/gold_01.mp3',
        'messages/gold/gold_02.mp3',
        'messages/gold/gold_03.mp3',
        'messages/gold/gold_04.mp3',
        'messages/gold/gold_05.mp3',
        'messages/gold/gold_06.mp3',
        'messages/gold/gold_07.mp3',
        // Sentences
        for (int i = 1; i <= 20; i++) 'sentences/s${i.toString().padLeft(2, '0')}.mp3',
      ]);
    } catch (e) {
      // ignore errors — no crash if missing files
    }
  }

  /// Plays the audio for a specific sentence (1–20)
  Future<void> playSentence(int index) async {
    final file = 'audio/sentences/s${index.toString().padLeft(2, '0')}.mp3';
    await _safePlay(file);
  }

  /// Plays a specific word (e.g., “the”, “and”)
  Future<void> playWord(String word) async {
    final safeWord = word.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    await _safePlay('audio/words/$safeWord.mp3');
  }

  /// Trophy sounds
  Future<void> playTrophyBronze() async => await _randomPlay('audio/messages/bronze', 5, 'bronze');
  Future<void> playTrophySilver() async => await _randomPlay('audio/messages/silver', 5, 'silver');
  Future<void> playTrophyGold() async => await _randomPlay('audio/messages/gold', 7, 'gold');

  /// Match feedback
  Future<void> playMatch() async => await _safePlay('audio/messages/regular/01.mp3');
  Future<void> playMismatch() async => await _safePlay('audio/messages/regular/02.mp3');

  /// Random play helper (for trophy variations)
  Future<void> _randomPlay(String folder, int count, String baseName) async {
    final n = 1 + (DateTime.now().millisecondsSinceEpoch % count);
    await _safePlay('$folder/${baseName}_${n.toString().padLeft(2, '0')}.mp3');
  }

  /// Central safe play function using the new AssetSource API
  Future<void> _safePlay(String relativePath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(relativePath));
    } catch (e) {
      // Silently ignore any asset errors
      // print('Audio load error: $relativePath -> $e');
    }
  }

  Future<void> dispose() async {
    await _player.stop();
    await _player.release();
    await _player.dispose();
  }
}
