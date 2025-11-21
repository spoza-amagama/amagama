// 📄 lib/services/round_service.dart
//
// RoundService — coordinates what happens when a round is complete:
// - increment cyclesCompleted
// - award trophies when reaching cyclesTarget
// - unlock next sentence when mastered
// - rebuild deck
// ---------------------------------------------------------------------------

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
    if (!_bound) return;

    // Only complete when all cards are matched.
    if (_deck.deck.any((c) => !c.isMatched)) return;

    final int idx = _sentences.currentSentence;
    final sentence = sentences[idx];
    final int sentenceId = sentence.id;
    final int target = _cycles.cyclesTarget;

    final before = _progress.bySentenceId(sentenceId);
    final beforeCycles = before.cyclesCompleted;

    // Increment cyclesCompleted.
    await _progress.recordSuccess(sentenceId);
    final after = _progress.bySentenceId(sentenceId);
    final afterCycles = after.cyclesCompleted;

    // Award trophies based on thresholds.
    await _trophies.awardForSentenceMastery();

    // Check if this sentence has just reached mastery.
    final bool mastered =
        beforeCycles < target && afterCycles >= target;

    // Celebrate & unlock next sentence.
    if (mastered) {
      await _audio.playTrophy(afterCycles);

      if (idx < sentences.length - 1) {
        await _sentences.setCurrent(idx + 1);
      }
    }

    // Always rebuild the deck for the (possibly new) sentence.
    _deck.resetForSentence(_sentences.currentSentence);
  }
}