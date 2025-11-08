// 📄 lib/app/amagama_app.dart
// ------------------------------------------------------------
// 🎮 AmagamaApp
// Root widget providing state controllers, theme, and routes.
// Launches with a splash screen before loading the game state.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🧠 State + Controllers
import 'package:amagama/state/index.dart';
import 'package:amagama/controllers/card_grid_controller.dart';

// 🎨 Theme + Screens
import 'package:amagama/theme/theme.dart';
import 'package:amagama/screens/index.dart';

// 🧩 Local
import 'package:amagama/app/loading_wrapper.dart';
import 'package:amagama/app/splash_screen.dart';

class AmagamaApp extends StatelessWidget {
  const AmagamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 🎮 Core game state
        ChangeNotifierProvider(create: (_) => GameController()..init()),

        // 🔊 Audio playback controller
        ChangeNotifierProvider(create: (_) => AudioControllerProvider()),

        // 🧩 Card grid interaction logic
        ChangeNotifierProvider(create: (_) => CardGridController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amagama',
        theme: buildTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(), // 🌅 Added splash screen
          '/home': (context) => const HomeScreen(),
          '/play': (context) => const PlayScreen(),
          '/grownups': (context) => const GrownUpsScreen(),
          '/loading': (context) => const LoadingWrapper(), // for internal transitions
        },
      ),
    );
  }
}
