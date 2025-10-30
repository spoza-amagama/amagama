// 📄 lib/main.dart
// Entry point for the Amagama app.
// Initializes game state, audio controller, and global providers.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/index.dart';
import 'screens/index.dart';
import 'theme/theme.dart';
import 'services/audio_service.dart';
import 'controllers/card_grid_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Preload all audio assets at startup
  await AudioService().preloadAll();

  runApp(const AmagamaApp());
}

class AmagamaApp extends StatelessWidget {
  const AmagamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 🎮 Core game state (words, deck, progress)
        ChangeNotifierProvider(create: (_) => GameController()..init()),

        // 🔊 Global audio management
        ChangeNotifierProvider(create: (_) => AudioControllerProvider()),

        // 🧩 Card grid logic (flip, glow, audio)
        ChangeNotifierProvider(create: (_) => CardGridController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amagama',
        theme: buildTheme(),
        home: const LoadingWrapper(),
      ),
    );
  }
}

class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final ready = game.progress.isNotEmpty && game.deck.isNotEmpty;

    if (!ready) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF8E1),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFC107),
          ),
        ),
      );
    }

    return const HomeScreen();
  }
}
