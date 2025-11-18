// 📄 lib/mixins/grid_audio_mixin.dart
import 'package:flutter/material.dart';
import 'package:amagama/services/audio/audio_service.dart';

/// 🔊 Handles sound behavior for card grids
mixin GridAudioMixin<T extends StatefulWidget> on State<T> {
  final AudioService _audio = AudioService();

  Future<void> playFlipAudio(dynamic card) async {
    await _audio.playWord(card.word);
  }

  Future<void> playMatchAudio(dynamic card) async {
    await _audio.playWord(card.word);
  }

  Future<void> playSentenceAudio(int sentenceIndex) async {
    await _audio.playSentence(sentenceIndex);
  }
}