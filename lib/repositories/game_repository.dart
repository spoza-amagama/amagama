// 📄 lib/repositories/game_repository.dart

import 'package:amagama/services/storage_service.dart';
import 'package:amagama/models/index.dart';

class GameRepository {
  final StorageService _storage = StorageService();

  Future<int> loadCurrentSentence() => _storage.loadCurrentSentence();
  Future<void> saveCurrentSentence(int idx) =>
      _storage.saveCurrentSentence(idx);

  Future<List<SentenceProgress>> loadProgress() => _storage.loadProgress();
  Future<void> saveProgress(List<SentenceProgress> progress) =>
      _storage.saveProgress(progress);

  Future<int> loadCyclesTarget() => _storage.loadCyclesTarget();
  Future<void> saveCyclesTarget(int value) =>
      _storage.saveCyclesTarget(value);

  // NEW global trophy totals
  Future<int> loadTotalBronze() => _storage.loadTotalBronze();
  Future<int> loadTotalSilver() => _storage.loadTotalSilver();
  Future<int> loadTotalGold() => _storage.loadTotalGold();

  Future<void> saveTotalBronze(int v) => _storage.saveTotalBronze(v);
  Future<void> saveTotalSilver(int v) => _storage.saveTotalSilver(v);
  Future<void> saveTotalGold(int v) => _storage.saveTotalGold(v);

  Future<void> resetAll() => _storage.resetAll();
}