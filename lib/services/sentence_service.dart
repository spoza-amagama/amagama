// 📄 lib/services/sentence_service.dart
//
// SentenceService — manages current sentence index, view index, and
// provides safe access to sentence data for the UI.
// Also persists the current sentence via GameRepository.

import 'package:amagama/data/index.dart';
import 'package:amagama/models/sentence.dart';   // ✅ Required for Sentence type
import 'package:amagama/repositories/game_repository.dart';

class SentenceService {
  final GameRepository _repo;

  SentenceService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  // ---------------------------------------------------------------------------
  // INTERNAL STATE
  // ---------------------------------------------------------------------------

  int _currentSentence = 0; // The sentence the learner is actively playing
  int _viewSentence = 0;    // UI-only index for the carousel

  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // GETTERS — Used across many widgets
  // ---------------------------------------------------------------------------

  /// True once init() has completed.
  bool get ready => _initialized;

  /// Index used in gameplay.
  int get currentSentence => _currentSentence;

  /// Index used by carousel.
  int get viewSentence => _viewSentence;

  /// Number of sentences in curriculum.
  int get total => sentences.length;

  /// Safety wrapper for sentence fetch.
  Sentence byIndex(int index) {
    if (index < 0 || index >= sentences.length) {
      return sentences[0];
    }
    return sentences[index];
  }

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    _currentSentence = await _repo.loadCurrentSentence();

    // Clamp invalid stored values
    if (_currentSentence < 0 || _currentSentence >= sentences.length) {
      _currentSentence = 0;
    }

    _viewSentence = _currentSentence;
    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // STATE UPDATES
  // ---------------------------------------------------------------------------

  /// Whether a sentence is unlocked for the learner.
  bool isUnlocked(int index) => index <= _currentSentence;

  /// UI-only update to the carousel position.
  void setView(int index) {
    if (index < 0 || index >= sentences.length) return;
    _viewSentence = index;
  }

  /// Updates both gameplay + carousel indexes.
  Future<void> setCurrent(int index) async {
    if (index < 0 || index >= sentences.length) return;
    _currentSentence = index;
    _viewSentence = index;
    await _repo.saveCurrentSentence(index);
  }

  // ---------------------------------------------------------------------------
  // NAVIGATION HELPERS
  // ---------------------------------------------------------------------------

  bool get hasNext => _currentSentence < sentences.length - 1;
  bool get hasPrevious => _currentSentence > 0;

  Future<void> next() async {
    if (!hasNext) return;
    await setCurrent(_currentSentence + 1);
  }

  Future<void> previous() async {
    if (!hasPrevious) return;
    await setCurrent(_currentSentence - 1);
  }

  // ---------------------------------------------------------------------------
  // RESET
  // ---------------------------------------------------------------------------

  Future<void> reset() async {
    _currentSentence = 0;
    _viewSentence = 0;
    await _repo.saveCurrentSentence(0);
  }
}