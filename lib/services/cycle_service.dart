// 📄 lib/services/cycle_service.dart
//
// CycleService — manages the cycles target (1–6) for each sentence,
// persisted via GameRepository.

import 'package:amagama/repositories/game_repository.dart';

class CycleService {
  final GameRepository _repo;

  CycleService({GameRepository? repo}) : _repo = repo ?? GameRepository();

  int _cyclesTarget = 6;
  int get cyclesTarget => _cyclesTarget;

  Future<void> init() async {
    _cyclesTarget = await _repo.loadCyclesTarget();
    if (_cyclesTarget < 1 || _cyclesTarget > 6) {
      _cyclesTarget = 6;
    }
  }

  Future<void> setCyclesTarget(int value) async {
    _cyclesTarget = value.clamp(1, 6);
    await _repo.saveCyclesTarget(_cyclesTarget);
  }

  Future<void> reset() async {
    _cyclesTarget = 6;
    await _repo.saveCyclesTarget(_cyclesTarget);
  }
}