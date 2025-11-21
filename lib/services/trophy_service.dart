// 📄 lib/services/trophy_service.dart
//
// TrophyService — week-free global trophy award system.
// Trophies now awarded based on "number of mastered sentences":
//
// Bronze →  1 mastered sentence
// Silver →  5 mastered sentences
// Gold   → 20 mastered sentences (all)
// ---------------------------------------------------------------------------

import 'package:amagama/repositories/game_repository.dart';

class TrophyService {
  final GameRepository _repo;

  TrophyService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  // Global totals
  int bronze = 0;
  int silver = 0;
  int gold = 0;

  /// Used by PlayScreen for gold confetti overlay.
  bool justUnlockedGold = false;

  // Read-only getters
  int get bronzeTotal => bronze;
  int get silverTotal => silver;
  int get goldTotal => gold;

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    bronze = await _repo.loadTotalBronze();
    silver = await _repo.loadTotalSilver();
    gold = await _repo.loadTotalGold();
  }

  // ---------------------------------------------------------------------------
  // RESET
  // ---------------------------------------------------------------------------

  Future<void> reset() async {
    bronze = 0;
    silver = 0;
    gold = 0;
    justUnlockedGold = false;
    await _saveTotals();
  }

  Future<void> _saveTotals() async {
    await _repo.saveTotalBronze(bronze);
    await _repo.saveTotalSilver(silver);
    await _repo.saveTotalGold(gold);
  }

  // ---------------------------------------------------------------------------
  // AWARDS (week-free & cycles-based)
  // ---------------------------------------------------------------------------

  /// Called ONLY when a sentence reaches cyclesTarget for the first time.
  /// (RoundService detects this condition)
  Future<void> awardForSentenceMastery() async {
    // 1️⃣ Bronze always increments
    bronze += 1;

    // 2️⃣ Silver unlocks at 5 mastered sentences
    if (bronze == 5) {
      silver += 1;
    }

    // 3️⃣ Gold unlocks at mastering ALL 20 sentences
    //    (adjust if you add/remove sentences)
    if (bronze == 20) {
      gold += 1;
      justUnlockedGold = true;
    }

    await _saveTotals();
  }

  // Consume the gold confetti trigger after UI shows it
  void consumeGoldConfetti() => justUnlockedGold = false;
}