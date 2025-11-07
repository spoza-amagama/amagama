// 📄 lib/main.dart
// ------------------------------------------------------------
// 🎮 Amagama — Entry Point
// Initializes game state, audio controller, and global providers.
// Defines routes for / (Home) and /play (Game).
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🧠 State + Controllers
import 'state/index.dart';
import 'controllers/card_grid_controller.dart';

// 🎵 Services
import 'services/audio/audio_service.dart';

// 🖥️ Screens
import 'screens/index.dart';

// 🎨 Theme
import 'theme/theme.dart';

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
        initialRoute: '/',
        routes: {
          '/': (context) => const LoadingWrapper(),
          '/home': (context) => const HomeScreen(),
          '/play': (context) => const PlayScreen(),
        },
      ),
    );
  }
}

/// 🕹️ Waits for game state to initialize before showing home screen
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
