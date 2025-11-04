// 📂 lib/controllers/game_controller.dart
import 'package:amagama/services/audio/audio_service.dart';

/// 🎮 GameController
/// ----------------------------------------------------
/// Manages gameplay flow for Amagama:
/// - Tracks current word and progress.
/// - Handles match events.
/// - Automatically triggers audio (word/sentence).
class PlayAudioController {
  final AudioService _audio = AudioService();

  /// List of words for the current sentence.
  final List<String> _sentenceWords;

  /// Sentence ID or index used to load sentence audio.
  final dynamic _sentenceId;

  /// Tracks which word player is currently matching.
  int _currentIndex = 0;

  PlayAudioController({
    required List<String> sentenceWords,
    required dynamic sentenceId,
  })  : _sentenceWords = sentenceWords,
        _sentenceId = sentenceId;

  /// Called when a word is successfully matched.
  /// Automatically plays next word or sentence audio.
  Future<void> onMatch() async {
    final isFinal = _currentIndex >= _sentenceWords.length - 1;

    if (isFinal) {
      // Final match: play sentence audio
      await _audio.handleMatch(
        isFinal: true,
        sentenceId: _sentenceId,
      );
      _currentIndex = 0; // reset for next sentence
    } else {
      // Not final: play next word
      final nextWord = _sentenceWords[_currentIndex + 1];
      await _audio.handleMatch(
        isFinal: false,
        nextWord: nextWord,
      );
      _currentIndex++;
    }
  }

  /// Reset sentence progress manually (optional)
  void reset() {
    _currentIndex = 0;
  }

  /// Returns current progress as fraction (0–1)
  double get progress =>
      _sentenceWords.isEmpty ? 0 : _currentIndex / _sentenceWords.length;
}
