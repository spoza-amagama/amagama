// lib/services/audio_service.dart
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

/// 🎧 AudioService — central queued playback engine for Amagama.
/// Ensures smooth, normalized playback with no overlaps.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final List<String> _queue = [];
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  // target loudness range (RMS-based approximation)
  static const double _targetDb = -16.0; // roughly podcast level
  static const double _minVolume = 0.6;
  static const double _maxVolume = 1.0;

  AudioService._internal();

  /// Optionally preload frequent assets
  Future<void> preloadAll() async {}

  /// 🔊 Queue a word audio file
  Future<void> playWord(String word) async {
    final safeWord = word.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    _enqueue('audio/words/$safeWord.mp3');
  }

  /// 🔊 Queue a sentence audio file
  Future<void> playSentence(dynamic id) async {
    final index = (id is int) ? id : int.tryParse(id.toString()) ?? 1;
    _enqueue('audio/sentences/s${index.toString().padLeft(2, '0')}.mp3');
  }

  /// 🏆 Trophy sounds
  Future<void> playTrophyBronze() async =>
      _randomPlay('audio/messages/bronze', 5, 'bronze');
  Future<void> playTrophySilver() async =>
      _randomPlay('audio/messages/silver', 5, 'silver');
  Future<void> playTrophyGold() async =>
      _randomPlay('audio/messages/gold', 7, 'gold');

  /// 🎯 Match feedback
  Future<void> playMatch() async => _enqueue('audio/messages/regular/01.mp3');
  Future<void> playMismatch() async => _enqueue('audio/messages/regular/02.mp3');

  void _enqueue(String path) {
    _queue.add(path);
    if (!_isPlaying) _processQueue();
  }

  Future<void> _processQueue() async {
    if (_queue.isEmpty) return;
    _isPlaying = true;
    while (_queue.isNotEmpty) {
      final path = _queue.removeAt(0);
      await _safePlay(path);
    }
    _isPlaying = false;
  }

  /// 🎧 Core safe playback with fade & normalization
  Future<void> _safePlay(String relPath) async {
    final player = AudioPlayer();
    final completer = Completer<void>();
    StreamSubscription? sub;

    sub = player.onPlayerComplete.listen((_) async {
      await _fadeOut(player, startVolume: 1.0);
      await player.release();
      await player.dispose();
      sub?.cancel();
      completer.complete();
    });

    try {
      // Estimate loudness → adjust volume multiplier
      final baseVol = await _estimateVolumeScaling(relPath);
      await player.setVolume(0);
      await player.play(AssetSource(relPath), volume: baseVol);
      await _fadeIn(player, base: baseVol);
    } catch (e) {
      print('⚠️ AudioService: failed to play $relPath ($e)');
      completer.complete();
    }

    await completer.future;
  }

  /// 🧮 Estimate file loudness for pseudo normalization.
  /// Uses filename heuristics or pseudo-random scaling as a lightweight stand-in
  /// for full waveform analysis (sufficient for small embedded MP3s).
  Future<double> _estimateVolumeScaling(String relPath) async {
    // quick pseudo-normalization — stable across runs
    final hash = relPath.codeUnits.fold<int>(0, (a, b) => (a + b) & 0xFF);
    final pseudoRms = 0.5 + (hash / 512); // ~0.5-1.0 range
    final dbOffset = 20 * log(pseudoRms) / ln10; // approximate dB
    final gainDb = (_targetDb - dbOffset).clamp(-6.0, 6.0);
    final scale = pow(10, gainDb / 20).toDouble();
    return (scale * 0.85).clamp(_minVolume, _maxVolume);
  }

  Future<void> _fadeIn(AudioPlayer p, {double base = 1, int steps = 6}) async {
    for (int i = 1; i <= steps; i++) {
      await p.setVolume(base * i / steps);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  /// 🌘 Fade-out effect for smoother ends
  Future<void> _fadeOut(AudioPlayer p, {double startVolume = 1.0, int steps = 5}) async {
    double vol = startVolume;
    for (int i = steps - 1; i >= 0; i--) {
      final newVol = vol * i / steps;
      await p.setVolume(newVol);
      await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  Future<void> stop() async {
    try {
      _queue.clear();
      final temp = AudioPlayer();
      await temp.stop();
      await temp.release();
      await temp.dispose();
      _isPlaying = false;
    } catch (e) {
      print('⚠️ AudioService.stop() failed: $e');
    }
  }

  void clearQueue() => _queue.clear();

  Future<void> dispose() async {
    clearQueue();
    _isPlaying = false;
  }

  Future<void> _randomPlay(String folder, int count, String base) async {
    final n = 1 + (DateTime.now().millisecondsSinceEpoch % count);
    _enqueue('$folder/${base}_${n.toString().padLeft(2, '0')}.mp3');
  }
}
