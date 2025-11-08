// 📄 lib/main.dart
// ------------------------------------------------------------
// 🚀 Entry Point
// Bootstraps Amagama by initializing audio and running the app.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/services/audio/audio_service.dart';
import 'package:amagama/app/amagama_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Preload all audio assets at startup
  await AudioService().preloadAll();

  runApp(const AmagamaApp());
}
