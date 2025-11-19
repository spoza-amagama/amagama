// 📄 lib/services/progress_service.dart
//
// ProgressService — manages per-sentence progress (cycles + trophies)
// and persists via GameRepository.

import 'package:amagama/models/index.dart';
import 'package:amagama/repositories/game_repository.dart';
import 'package:amagama/data/index.dart';

class ProgressService {
  final GameRepository _repo;

  ProgressService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  List<SentenceProgress> _all = [];
  List<SentenceProgress> get all => List.unmodifiable(_all);

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

  SentenceProgress byIndex(int index) => _all[index];

  SentenceProgress bySentenceId(String id) =>
      _all.firstWhere((p) => p.sentenceId == id);

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
}