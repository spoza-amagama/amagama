// 📄 lib/screens/loading_screen.dart
//
// ⏳ LoadingScreen — waits for GameController to be ready,
// then redirects to the Home route exactly once.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/routes/index.dart';
import 'package:amagama/theme/index.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_navigated) return;

    final game = context.watch<GameController>();
    final ready = game.progress.isNotEmpty && game.deck.isNotEmpty;

    if (ready) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
