// 📄 lib/services/audio/audio_service.dart
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

/// 🎧 AudioService
/// ----------------------------------------------------
/// Centralized sequential audio playback for Amagama.
/// Features:
/// - Word and sentence audio playback
/// - Queue-based sequential sound handling (no overlaps)
/// - Trophy rewards and match/mismatch effects
/// - Singleton instance (global audio manager)
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final List<String> _queue = [];
  bool _isPlaying = false;
  String? _lastFile; // prevents repeat spam

  AudioService._internal() {
    _player.onPlayerComplete.listen((_) => _playNext());
  }

  bool get isPlaying => _isPlaying;

  // ───────────────────────────────────────────────
  // ⚙️ INITIALIZATION
  // ───────────────────────────────────────────────

  /// Optional: preload frequently used clips (called in main())
  Future<void> preloadAll() async {
    // Example (uncomment if needed):
    // await _player.setSource(AssetSource('audio/effects/match.mp3'));
  }

  // ───────────────────────────────────────────────
  // 🔊 CORE PLAYBACK METHODS
  // ───────────────────────────────────────────────

  /// Plays a single word file: audio/words/{word}.mp3
  Future<void> playWord(String word) async {
    final safeWord = word.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    final path = 'audio/words/$safeWord.mp3';
    _enqueue(path);
  }

  /// Plays a sentence audio clip: audio/sentences/sXX.mp3
  Future<void> playSentence(dynamic id) async {
    final index = (id is int) ? id : int.tryParse(id.toString()) ?? 1;
    final path = 'audio/sentences/s${index.toString().padLeft(2, '0')}.mp3';
    _enqueue(path);
  }

  // ───────────────────────────────────────────────
  // 🧩 MATCH / MISMATCH FEEDBACK
  // ───────────────────────────────────────────────

  /// Plays a short "match success" jingle
  Future<void> playMatch() async {
    _enqueue('audio/effects/match.mp3');
  }

  /// Plays a short "mismatch / error" sound
  Future<void> playMismatch() async {
    _enqueue('audio/effects/mismatch.mp3');
  }

  // ───────────────────────────────────────────────
  // 🏆 TROPHY REWARD AUDIO
  // ───────────────────────────────────────────────

  Future<void> playTrophyBronze() async =>
      _enqueueRandom('audio/messages/bronze', 5, 'bronze');

  Future<void> playTrophySilver() async =>
      _enqueueRandom('audio/messages/silver', 5, 'silver');

  Future<void> playTrophyGold() async =>
      _enqueueRandom('audio/messages/gold', 7, 'gold');

  Future<void> _enqueueRandom(String folder, int count, String baseName) async {
    final n = 1 + (DateTime.now().millisecondsSinceEpoch % count);
    final file = '$folder/${baseName}_${n.toString().padLeft(2, '0')}.mp3';
    _enqueue(file);
  }

  // ───────────────────────────────────────────────
  // 🤝 MATCH HANDLER (used by controllers)
  // ───────────────────────────────────────────────

  Future<void> handleMatch({
    required bool isFinal,
    String? nextWord,
    dynamic sentenceId,
  }) async {
    if (isFinal) {
      if (sentenceId != null) {
        await playSentence(sentenceId);
      }
    } else if (nextWord != null) {
      await playWord(nextWord);
    }
  }

  // ───────────────────────────────────────────────
  // 🔁 INTERNAL QUEUE HANDLING
  // ───────────────────────────────────────────────

  void _enqueue(String filePath) {
    if (_lastFile == filePath && _isPlaying) return; // debounce repeat
    _queue.add(filePath);
    _lastFile = filePath;
    if (!_isPlaying) _playNext();
  }

  Future<void> _playNext() async {
    if (_queue.isEmpty) {
      _isPlaying = false;
      return;
    }

    _isPlaying = true;
    final nextFile = _queue.removeAt(0);
    try {
      await _player.stop(); // clean slate
      await _player.play(AssetSource(nextFile));
    } catch (e) {
      // ignore missing assets gracefully
      print('⚠️ AudioService: failed to play $nextFile — $e');
    } finally {
      _isPlaying = false;
      if (_queue.isNotEmpty) _playNext();
    }
  }

  // ───────────────────────────────────────────────
  // 🧹 CLEANUP
  // ───────────────────────────────────────────────

  Future<void> stop() async {
    await _player.stop();
    _queue.clear();
    _isPlaying = false;
  }

  Future<void> dispose() async {
    await stop();
    await _player.release();
  }
}
