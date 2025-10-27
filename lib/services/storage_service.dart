// /lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/progress.dart';

class StorageService {
  static const _kCurrentSentence = 'current_sentence';
  static const _kProgress = 'progress_v1';
  static const _kCyclesTarget = 'cycles_target'; // X (1..6), default 6

  Future<int> loadCurrentSentence() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kCurrentSentence) ?? 0;
    }

  Future<void> saveCurrentSentence(int index) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kCurrentSentence, index);
  }

  Future<List<SentenceProgress>> loadProgress() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_kProgress) ?? [];
    return raw.map((s) => SentenceProgress.fromJson(jsonDecode(s))).toList();
  }

  Future<void> saveProgress(List<SentenceProgress> list) async {
    final sp = await SharedPreferences.getInstance();
    final raw = list.map((p) => jsonEncode(p.toJson())).toList();
    await sp.setStringList(_kProgress, raw);
  }

  Future<int> loadCyclesTarget() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kCyclesTarget) ?? 6;
  }

  Future<void> saveCyclesTarget(int x) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kCyclesTarget, x.clamp(1, 6));
  }

  Future<void> resetAll() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
