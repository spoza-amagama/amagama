// 📄 lib/app/loading_wrapper.dart
// ------------------------------------------------------------
// 🕹️ LoadingWrapper
// Waits for game state initialization before showing HomeScreen.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/screens/home_screen.dart';

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
