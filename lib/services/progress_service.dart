// 📄 lib/services/progress_service.dart
//
// ProgressService — manages cyclesCompleted + trophies per sentence.
// Week-free, attempts removed, matches SentenceProgress model exactly.
// ---------------------------------------------------------------------------

import 'package:amagama/models/sentence_progress.dart';
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
  // UPDATE HELPERS
  // ---------------------------------------------------------------------------

  void updateAtIndex(int index, SentenceProgress updated) {
    if (index < 0 || index >= _all.length) return;
    _all[index] = updated;
  }

  // ---------------------------------------------------------------------------
  // RECORD PROGRESS (attempts REMOVED)
  // ---------------------------------------------------------------------------

  Future<void> recordSuccess(int sentenceId) async {
    final idx = _all.indexWhere((p) => p.sentenceId == sentenceId);
    if (idx == -1) return;

    final p = _all[idx];

    final updated = p.copyWith(
      cyclesCompleted: p.cyclesCompleted + 1,
    );

    _all[idx] = updated;

    await save();
  }

  // ---------------------------------------------------------------------------
  // SAVE / RESET
  // ---------------------------------------------------------------------------

  Future<void> save() async => _repo.saveProgress(_all);

  Future<void> reset() async {
    _all = sentences
        .map(
          (s) => SentenceProgress(
            sentenceId: s.id,
            cyclesCompleted: 0,
            trophyBronze: false,
            trophySilver: false,
            trophyGold: false,
          ),
        )
        .toList();

    await save();
  }
}