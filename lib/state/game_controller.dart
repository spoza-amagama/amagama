// 📄 lib/state/game_controller.dart
//
// 🎮 GameController — now includes CycleService for cyclesTarget configuration.

import 'package:flutter/material.dart';
import '../services/index.dart';

class GameController extends ChangeNotifier {
  final sentences = SentenceService();
  final cycles = CycleService();          // ✅ back in, but simplified
  final trophies = TrophyService();
  final pin = PinService();
  final progress = ProgressService();
  final deck = DeckService();
  final rounds = RoundService();

  Future<void> init() async {
    await sentences.init();
    await cycles.init();                  // ✅ initialise cyclesTarget
    await trophies.init();
    await pin.init();
    await progress.init();
    await deck.init(sentences.currentSentence);

    rounds.bind(
      cycles: cycles,                     // ✅ hand cycles into RoundService
      progress: progress,
      trophies: trophies,
      sentences: sentences,
      deck: deck,
    );

    notifyListeners();
  }

  Future<void> resetAll() async {
    await sentences.reset();
    await cycles.reset();                 // ✅ reset cycles config to default
    await trophies.reset();
    await pin.reset();
    await progress.reset();
    await deck.reset();

    await init();
  }

  // ------------------------------------------------------------
  // CYCLES CONFIG (for GrownUpsScreen)
  // ------------------------------------------------------------

  Future<void> updateCyclesTarget(int value) async {
    await cycles.setCyclesTarget(value);
    notifyListeners();
  }
}