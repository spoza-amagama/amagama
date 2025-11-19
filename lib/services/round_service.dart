// 📄 lib/services/round_service.dart
//
// RoundService — coordinates what happens when a round is complete:
// - update per-sentence cycles
// - award global trophies
// - save progress
// - unlock the next sentence
// - rebuild deck for the new/current sentence
//
// This mirrors the original _onRoundComplete logic from GameController,
// but depends on other services instead of owning all state directly.

import 'package:amagama/data/index.dart';
import 'package:amagama/services/audio_notifier.dart';
import 'package:amagama/services/cycle_service.dart';
import 'package:amagama/services/deck_service.dart';
import 'package:amagama/services/progress_service.dart';
import 'package:amagama/services/sentence_service.dart';
import 'package:amagama/services/trophy_service.dart';

class RoundService {
  final AudioNotifier _audio;

  RoundService({AudioNotifier? audioNotifier})
      : _audio = audioNotifier ?? AudioNotifier();

  late CycleService _cycles;
  late ProgressService _progress;
  late TrophyService _trophies;
  late SentenceService _sentences;
  late DeckService _deck;

  bool _bound = false;

  void bind({
    required CycleService cycles,
    required ProgressService progress,
    required TrophyService trophies,
    required SentenceService sentences,
    required DeckService deck,
  }) {
    _cycles = cycles;
    _progress = progress;
    _trophies = trophies;
    _sentences = sentences;
    _deck = deck;
    _bound = true;
  }

  Future<void> handleRoundComplete() async {
    if (!_bound) {
      // Not configured yet; nothing to do.
      return;
    }

    if (_deck.deck.any((c) => !c.isMatched)) {
      return;
    }

    final currentIndex = _sentences.currentSentence;
    final sentenceId = sentences[currentIndex].id;
    final idx =
        _progress.all.indexWhere((p) => p.sentenceId == sentenceId);
    if (idx == -1) return;

    final old = _progress.all[idx];
    final newCycles =
        (old.cyclesCompleted + 1).clamp(0, _cycles.cyclesTarget);

    await _audio.playTrophy(newCycles);

    await _trophies.applyAwards(
      newCycles: newCycles,
      oldProgress: old,
      cyclesTarget: _cycles.cyclesTarget,
    );

    final updated = old.copyWith(
      cyclesCompleted: newCycles,
      trophyBronze: old.trophyBronze || newCycles >= 2,
      trophySilver: old.trophySilver || newCycles >= 4,
      trophyGold: old.trophyGold || newCycles >= _cycles.cyclesTarget,
    );

    _progress.updateAtIndex(idx, updated);
    await _progress.save();

    if (newCycles >= _cycles.cyclesTarget &&
        currentIndex < sentences.length - 1) {
      await _sentences.setCurrent(currentIndex + 1);
    }

    _deck.resetForSentence(_sentences.currentSentence);
  }
}