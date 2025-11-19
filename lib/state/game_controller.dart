// 📄 lib/state/game_controller.dart

import 'package:flutter/material.dart';
import '../services/index.dart';

class GameController extends ChangeNotifier {
  final sentences = SentenceService();
  final cycles = CycleService();
  final trophies = TrophyService();
  final pin = PinService();
  final progress = ProgressService();
  final deck = DeckService();
  final rounds = RoundService();

  Future<void> init() async {
    await sentences.init();
    await cycles.init();
    await trophies.init();
    await pin.init();
    await progress.init();
    await deck.init(sentences.currentSentence);

    rounds.bind(
      cycles: cycles,
      trophies: trophies,
      progress: progress,
      sentences: sentences,
      deck: deck,
    );

    notifyListeners();
  }

  Future<void> resetAll() async {
    await sentences.reset();
    await cycles.reset();
    await trophies.reset();
    await pin.reset();
    await progress.reset();
    await deck.reset();

    await init();
  }
}