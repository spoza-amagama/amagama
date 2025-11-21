// 📄 lib/main.dart
// Entry point for Amagama — bootstraps services and runs the root app widget.

import 'package:flutter/material.dart';

import 'services/audio/audio_service.dart';
import 'widgets/app/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioService().preloadAll();
  runApp(const AmagamaApp());
}