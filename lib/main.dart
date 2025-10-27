// /lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/index.dart';
import 'screens/index.dart';
import 'theme/theme.dart';

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
          child: CircularProgressIndicator(color: Color(0xFFFFC107)),
        ),
      );
    }

    return const HomeScreen();
  }
}
