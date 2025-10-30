// lib/state/audio_controller_provider.dart
import 'package:flutter/material.dart';
import 'package:amagama/services/audio_service.dart';

class AudioControllerProvider extends ChangeNotifier {
  final AudioService _audio = AudioService();

  AudioService get audio => _audio;

  Future<void> stopAll() async {
    await _audio.stop();
    notifyListeners();
  }
}
