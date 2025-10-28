import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';

class StorageService {
  static const _progressKey = 'progress';
  static const _sentenceKey = 'currentSentence';
  static const _cyclesKey = 'cyclesTarget';

  Future<List<SentenceProgress>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_progressKey);

    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return [];

      // 🧹 SANITIZE malformed or null entries safely
      final List<SentenceProgress> safeList = [];
      for (final item in decoded) {
        try {
          if (item is Map<String, dynamic>) {
            safeList.add(SentenceProgress.fromJson(item));
          } else if (item is Map) {
            safeList.add(SentenceProgress.fromJson(
              Map<String, dynamic>.from(item),
            ));
          }
        } catch (e) {
          // Log & skip corrupted entries
          print('⚠️ Skipping malformed progress entry: $e');
        }
      }

      // Re-save cleaned data
      await saveProgress(safeList);
      return safeList;
    } catch (e) {
      print('⚠️ Progress load failed — resetting: $e');
      await saveProgress([]);
      return [];
    }
  }

  Future<void> saveProgress(List<SentenceProgress> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_progressKey, jsonString);
  }

  Future<int> loadCurrentSentence() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sentenceKey) ?? 0;
  }

  Future<void> saveCurrentSentence(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sentenceKey, index);
  }

  Future<int> loadCyclesTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cyclesKey) ?? 6;
  }

  Future<void> saveCyclesTarget(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cyclesKey, value);
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
