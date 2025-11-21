// 📄 lib/services/trophy_service.dart
//
// TrophyService — tracks global trophy totals and applies awards
// based on cycle thresholds. Works together with ProgressService.

import 'package:amagama/models/index.dart';
import 'package:amagama/repositories/game_repository.dart';

class TrophyService {
  final GameRepository _repo;

  TrophyService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  // ---------------------------------------------------------------------------
  // GLOBAL TROPHY TOTALS
  // ---------------------------------------------------------------------------

  int bronze = 0;
  int silver = 0;
  int gold = 0;

  // Used by confetti system (Gold only)
  bool justUnlockedGold = false;

  // Read-only wrappers (fixes analyzer errors such as bronzeTotal)
  int get bronzeTotal => bronze;
  int get silverTotal => silver;
  int get goldTotal => gold;

  // ---------------------------------------------------------------------------
  // INIT + RESET
  // ---------------------------------------------------------------------------

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

  Future<void> reset() async {
    bronze = 0;
    silver = 0;
    gold = 0;
    justUnlockedGold = false;
    await _saveTotals();
  }

  // ---------------------------------------------------------------------------
  // AWARD SYSTEM
  // ---------------------------------------------------------------------------
  //
  // Called by RoundService after each cycle update. Ensures trophies are
  // *only awarded once* per sentence and prevents double counting.
  //
  // Thresholds:
  // - Bronze  → 2 cycles
  // - Silver  → 4 cycles
  // - Gold    → cyclesTarget (exactly what you configure)

  Future<void> applyAwards({
    required int newCycles,
    required SentenceProgress oldProgress,
    required int cyclesTarget,
  }) async {
    bool changed = false;

    // BRONZE ──────────────────────────────────────────────
    if (newCycles >= 2 && !oldProgress.trophyBronze) {
      bronze += 1;
      changed = true;
    }

    // SILVER ──────────────────────────────────────────────
    if (newCycles >= 4 && !oldProgress.trophySilver) {
      silver += 1;
      changed = true;
    }

    // GOLD ────────────────────────────────────────────────
    if (newCycles >= cyclesTarget && !oldProgress.trophyGold) {
      gold += 1;
      justUnlockedGold = true; // Confetti will trigger once
      changed = true;
    }

    if (changed) {
      await _saveTotals();
    }
  }

  /// A helper wrapper for readability when updating *one* sentence.
  Future<void> applyAwardsForSentence({
    required SentenceProgress before,
    required int afterCycles,
    required int cyclesTarget,
  }) {
    return applyAwards(
      newCycles: afterCycles,
      oldProgress: before,
      cyclesTarget: cyclesTarget,
    );
  }

  // ---------------------------------------------------------------------------
  // QUERY HELPERS
  // ---------------------------------------------------------------------------

  /// Returns the trophy state for a given SentenceProgress.
  ({bool bronze, bool silver, bool gold}) awardStateFor(SentenceProgress p) {
    return (
      bronze: p.trophyBronze,
      silver: p.trophySilver,
      gold: p.trophyGold,
    );
  }

  /// Reset the gold confetti trigger.
  void consumeGoldConfetti() {
    justUnlockedGold = false;
  }
}