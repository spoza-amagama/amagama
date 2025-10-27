import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/index.dart';
import 'screens/index.dart';
import 'theme/index.dart'; // ✅ add this import for buildTheme()

void main() {
  runApp(const AmagamaApp());
}

class AmagamaApp extends StatelessWidget {
  const AmagamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController()..init(),
      child: MaterialApp(
        title: 'Amagama',
        theme: buildTheme(brightness: Brightness.light),  // ✅ Light theme
        darkTheme: buildTheme(brightness: Brightness.dark), // ✅ Dark theme
        themeMode: ThemeMode.system, // ✅ Follow device setting
        home: const LoadingWrapper(),
        debugShowCheckedModeBanner: false, // ✅ Hide debug banner
      ),
    );
  }
}

class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // ✅ Wait until progress list and deck are initialized
    final ready = game.progress.isNotEmpty && game.deck.isNotEmpty;

    if (!ready) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF8E1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/logo/amagama_logo.png'),
                width: 120,
                height: 120,
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(color: Color(0xFFFFC107)),
            ],
          ),
        ),
      );
    }

    return const HomeScreen();
  }
}
