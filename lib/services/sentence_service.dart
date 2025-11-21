// 📄 lib/services/sentence_service.dart
//
// SentenceService — manages the learner’s current sentence,
// handles safe navigation, and persists progress.
// Week logic removed (no week monitoring).
// ---------------------------------------------------------------------------

import 'package:amagama/data/index.dart';
import 'package:amagama/models/sentence.dart';
import 'package:amagama/repositories/game_repository.dart';

class SentenceService {
  final GameRepository _repo;

  SentenceService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  // ---------------------------------------------------------------------------
  // INTERNAL STATE
  // ---------------------------------------------------------------------------

  /// The sentence the learner is actively playing.
  int _currentSentence = 0;

  /// UI-only index for previews / carousel.
  int _viewSentence = 0;

  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // GETTERS — Used across widgets
  // ---------------------------------------------------------------------------

  bool get ready => _initialized;

  int get currentSentence => _currentSentence;

  int get viewSentence => _viewSentence;

  /// Number of sentences in the curriculum.
  int get total => sentences.length;

  /// The actual Sentence object the learner is currently on.
  Sentence get currentSentenceData => sentences[_currentSentence];

  /// Safe sentence access.
  Sentence byIndex(int index) =>
      (index < 0 || index >= sentences.length) ? sentences[0] : sentences[index];

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    final loaded = await _repo.loadCurrentSentence();

    // Clamp invalid stored values
    if (loaded < 0 || loaded >= sentences.length) {
      _currentSentence = 0;
    } else {
      _currentSentence = loaded;
    }

    _viewSentence = _currentSentence;
    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // STATE UPDATES
  // ---------------------------------------------------------------------------

  /// A sentence is unlocked if it is at or before the learner’s furthest progress.
  bool isUnlocked(int index) => index <= _currentSentence;

  /// UI-only carousel navigation.
  void setView(int index) {
    if (index < 0 || index >= sentences.length) return;
    _viewSentence = index;
  }

  /// Updates the active sentence and persists the change.
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
    if (hasNext) {
      await setCurrent(_currentSentence + 1);
    }
  }

  Future<void> previous() async {
    if (hasPrevious) {
      await setCurrent(_currentSentence - 1);
    }
  }

  // ---------------------------------------------------------------------------
  // RESET — full restart for the learner.
  // ---------------------------------------------------------------------------

  Future<void> reset() async {
    _currentSentence = 0;
    _viewSentence = 0;
    await _repo.saveCurrentSentence(0);
  }
}