// 📄 lib/services/progress_service.dart
//
// ProgressService — manages per-sentence progress (cycles + trophies)
// and persists via GameRepository.
//
// NOTE: sentenceId is an int everywhere in the data model, so this service
// now uses int instead of String for lookup and consistency.

import 'package:amagama/models/index.dart';
import 'package:amagama/repositories/game_repository.dart';
import 'package:amagama/data/index.dart';

class ProgressService {
  final GameRepository _repo;

  ProgressService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  List<SentenceProgress> _all = [];
  List<SentenceProgress> get all => List.unmodifiable(_all);

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------
  Future<void> init() async {
    _all = await _repo.loadProgress();

    final existingIds = _all.map((p) => p.sentenceId).toSet();

    // Ensure every sentence has an entry
    for (final sentence in sentences) {
      if (!existingIds.contains(sentence.id)) {
        _all.add(
          SentenceProgress(
            sentenceId: sentence.id,
            cyclesCompleted: 0,
            trophyBronze: false,
            trophySilver: false,
            trophyGold: false,
          ),
        );
      }
    }

    _all.sort((a, b) => a.sentenceId.compareTo(b.sentenceId));
  }

  // ---------------------------------------------------------------------------
  // ACCESSORS
  // ---------------------------------------------------------------------------

  SentenceProgress byIndex(int index) => _all[index];

  SentenceProgress? byIndexOrNull(int index) =>
      (index < 0 || index >= _all.length) ? null : _all[index];

  /// Lookup by int (matches SentenceProgress.sentenceId)
  SentenceProgress bySentenceId(int id) => _all.firstWhere(
        (p) => p.sentenceId == id,
        orElse: () => SentenceProgress(
          sentenceId: id,
          cyclesCompleted: 0,
          trophyBronze: false,
          trophySilver: false,
          trophyGold: false,
        ),
      );

  // ---------------------------------------------------------------------------
  // UPDATE + SAVE
  // ---------------------------------------------------------------------------

  void updateAtIndex(int index, SentenceProgress updated) {
    if (index < 0 || index >= _all.length) return;
    _all[index] = updated;
  }

  Future<void> save() async {
    await _repo.saveProgress(_all);
  }

  Future<void> reset() async {
    _all = [];
    await _repo.saveProgress(_all);
  }

  // ---------------------------------------------------------------------------
  // METRICS
  // ---------------------------------------------------------------------------

  int countCompleted(int cyclesTarget) {
    return _all.where((p) => p.cyclesCompleted >= cyclesTarget).length;
  }

  int totalCycles() {
    return _all.fold<int>(0, (sum, p) => sum + p.cyclesCompleted);
  }
}