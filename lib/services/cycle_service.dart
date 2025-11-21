// 📄 lib/services/cycle_service.dart
//
// CycleService — stores and persists cyclesTarget (2–6).
// Default = 6; configurable in Grownups screen.

import 'package:amagama/repositories/game_repository.dart';

class CycleService {
  static const int minCycles = 2;
  static const int maxCycles = 6;
  static const int defaultCycles = 6;

  final GameRepository _repo;

  CycleService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  int _cyclesTarget = defaultCycles;

  int get cyclesTarget => _cyclesTarget;

  // ---------------------------------------------------------------------------
  // INIT
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    final loaded = await _repo.loadCyclesTarget();

    _cyclesTarget = loaded.clamp(minCycles, maxCycles);
    }

  // ---------------------------------------------------------------------------
  // UPDATE + SAVE
  // ---------------------------------------------------------------------------

  Future<void> setCyclesTarget(int value) async {
    final clamped = value.clamp(minCycles, maxCycles);
    _cyclesTarget = clamped;
    await _repo.saveCyclesTarget(clamped);
  }

  // ---------------------------------------------------------------------------
  // RESET
  // ---------------------------------------------------------------------------

  Future<void> reset() async {
    _cyclesTarget = defaultCycles;
    await _repo.saveCyclesTarget(defaultCycles);
  }
}