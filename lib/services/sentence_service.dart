// 📄 lib/services/sentence_service.dart
//
// SentenceService — manages current sentence index and view index
// for the UI, and persists the current sentence via GameRepository.

import 'package:amagama/data/index.dart';
import 'package:amagama/repositories/game_repository.dart';

class SentenceService {
  final GameRepository _repo;

  SentenceService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  int _currentSentence = 0;
  int get currentSentence => _currentSentence;

  int _viewSentence = 0;
  int get viewSentence => _viewSentence;

  Future<void> init() async {
    _currentSentence = await _repo.loadCurrentSentence();
    _viewSentence = _currentSentence;
  }

  bool isUnlocked(int index) => index <= _currentSentence;

  void setView(int index) {
    if (index < 0 || index >= sentences.length) return;
    _viewSentence = index;
  }

  Future<void> setCurrent(int index) async {
    if (index < 0 || index >= sentences.length) return;
    _currentSentence = index;
    _viewSentence = index;
    await _repo.saveCurrentSentence(index);
  }

  /// Resets back to the first sentence, but does not touch repository storage.
  Future<void> reset() async {
    _currentSentence = 0;
    _viewSentence = 0;
    await _repo.saveCurrentSentence(0);
  }
}