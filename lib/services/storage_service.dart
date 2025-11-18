// 📄 lib/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:amagama/models/index.dart';
import 'dart:convert';

class StorageService {
  static const _keyProgress = 'progress_list';
  static const _keyCurrentSentence = 'current_sentence';
  static const _keyCyclesTarget = 'cycles_target';

  // NEW global trophy keys
  static const _keyTotalBronze = 'total_bronze';
  static const _keyTotalSilver = 'total_silver';
  static const _keyTotalGold = 'total_gold';

  // ---------------------------------------------------------------------------
  // CURRENT SENTENCE
  // ---------------------------------------------------------------------------
  Future<int> loadCurrentSentence() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentSentence) ?? 0;
  }

  Future<void> saveCurrentSentence(int idx) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyCurrentSentence, idx);
  }

  // ---------------------------------------------------------------------------
  // PROGRESS LIST
  // ---------------------------------------------------------------------------
  Future<List<SentenceProgress>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyProgress);

    if (raw == null) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => SentenceProgress.fromJson(e)).toList();
  }

  Future<void> saveProgress(List<SentenceProgress> progress) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _keyProgress,
      jsonEncode(progress.map((e) => e.toJson()).toList()),
    );
  }

  // ---------------------------------------------------------------------------
  // CYCLES TARGET
  // ---------------------------------------------------------------------------
  Future<int> loadCyclesTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCyclesTarget) ?? 6;
  }

  Future<void> saveCyclesTarget(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyCyclesTarget, value);
  }

  // ---------------------------------------------------------------------------
  // GLOBAL TROPHY TOTALS
  // ---------------------------------------------------------------------------
  Future<int> loadTotalBronze() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalBronze) ?? 0;
  }

  Future<int> loadTotalSilver() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalSilver) ?? 0;
  }

  Future<int> loadTotalGold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalGold) ?? 0;
  }

  Future<void> saveTotalBronze(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyTotalBronze, value);
  }

  Future<void> saveTotalSilver(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyTotalSilver, value);
  }

  Future<void> saveTotalGold(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyTotalGold, value);
  }

  // ---------------------------------------------------------------------------
  // RESET EVERYTHING
  // ---------------------------------------------------------------------------
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}