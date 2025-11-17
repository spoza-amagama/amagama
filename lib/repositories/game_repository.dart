// 📄 lib/repositories/game_repository.dart
import 'package:amagama/services/storage_service.dart';
import 'package:amagama/models/index.dart';

/// 💾 Handles game persistence — saving and loading progress and settings.
class GameRepository {
  final StorageService _storage = StorageService();

  // 🔹 Current Sentence
  Future<int> loadCurrentSentence() => _storage.loadCurrentSentence();
  Future<void> saveCurrentSentence(int idx) =>
      _storage.saveCurrentSentence(idx);

  // 🔹 Progress
  Future<List<SentenceProgress>> loadProgress() => _storage.loadProgress();
  Future<void> saveProgress(List<SentenceProgress> progress) =>
      _storage.saveProgress(progress);

  // 🔹 Cycles target
  Future<int> loadCyclesTarget() => _storage.loadCyclesTarget();
  Future<void> saveCyclesTarget(int value) => _storage.saveCyclesTarget(value);

  // 🔹 Reset everything
  Future<void> resetAll() => _storage.resetAll();
}