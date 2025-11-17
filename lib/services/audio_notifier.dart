// 📄 lib/services/audio_notifier.dart
//
// 🔊 AudioNotifier
// ------------------------------------------------------------
// Lightweight service for managing in-game sound cues in Amagama.
//
// RESPONSIBILITIES
// • Plays short audio cues for events like matches or trophies.
// • Queues or debounces playback to avoid overlapping sounds.
// • Bridges between UI/game logic and [AudioService].
// • Handles small delays for smoother sequencing after animations.
//
// DEPENDENCIES
// • [AudioService] — low-level sequential audio player.
// • [AssetSource] audio files organized under assets/audio/.
//
// RELATED CLASSES
// • [GameController] — triggers trophy sounds and word audio.
// • [AudioService] — actual audio playback engine.
//

import 'dart:async';
import 'package:amagama/services/audio/audio_service.dart';

class AudioNotifier {
  final AudioService _audio = AudioService();

  /// Plays the pronunciation for a word after a small delay.
  Future<void> playWord(String word) async {
    await Future.delayed(const Duration(milliseconds: 50));
    await _audio.playWord(word);
  }

  /// Plays a trophy sound according to the completed cycle number.
  Future<void> playTrophy(int cycle) async {
    String sound;
    if (cycle < 2) {
      sound = 'audio/trophy_bronze.mp3';
    } else if (cycle < 4) {
      sound = 'audio/trophy_silver.mp3';
    } else {
      sound = 'audio/trophy_gold.mp3';
    }

    await Future.delayed(const Duration(milliseconds: 200));
    await _audio.playSentence(sound);
  }
}