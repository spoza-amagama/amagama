// 📄 lib/services/trophy_service.dart
//
// TrophyService — tracks global trophy totals and applies awards
// based on cycle thresholds.

import 'package:amagama/models/index.dart';
import 'package:amagama/repositories/game_repository.dart';

class TrophyService {
  final GameRepository _repo;

  TrophyService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  int bronze = 0;
  int silver = 0;
  int gold = 0;

  bool justUnlockedGold = false;

  Future<void> init() async {
    bronze = await _repo.loadTotalBronze();
    silver = await _repo.loadTotalSilver();
    gold = await _repo.loadTotalGold();
  }

  Future<void> _saveTotals() async {
    await _repo.saveTotalBronze(bronze);
    await _repo.saveTotalSilver(silver);
    await _repo.saveTotalGold(gold);
  }

  /// Apply global trophies based on the new cycle count for a sentence.
  /// Mirrors the original _awardTrophies logic in GameController.
  Future<void> applyAwards({
    required int newCycles,
    required SentenceProgress oldProgress,
    required int cyclesTarget,
  }) async {
    bool awardBronze = false;
    bool awardSilver = false;
    bool awardGold = false;

    if (newCycles >= 2 && !oldProgress.trophyBronze) {
      awardBronze = true;
      bronze += 1;
    }

    if (newCycles >= 4 && !oldProgress.trophySilver) {
      awardSilver = true;
      silver += 1;
    }

    if (newCycles >= cyclesTarget && !oldProgress.trophyGold) {
      awardGold = true;
      gold += 1;
      justUnlockedGold = true;
    }

    if (awardBronze || awardSilver || awardGold) {
      await _saveTotals();
    }
  }

  void consumeGoldConfetti() {
    justUnlockedGold = false;
  }

  Future<void> reset() async {
    bronze = 0;
    silver = 0;
    gold = 0;
    justUnlockedGold = false;
    await _saveTotals();
  }
}