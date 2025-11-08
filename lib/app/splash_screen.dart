// 📄 lib/app/splash_screen.dart
//
// 🌅 SplashScreen
// ------------------------------------------------------------
// Displays the Amagama logo briefly, then fades into HomeScreen
// once the game state is initialized.
//
// RESPONSIBILITIES
// • Center and fade in logo
// • Wait for GameController to load data
// • Smooth transition to HomeScreen
//
// DEPENDENCIES
// • [GameController] — used to check when deck + progress are ready
// • [HomeScreen] — target destination

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Wait until GameController is initialized
    await Future.delayed(const Duration(milliseconds: 1800));
    final game = context.read<GameController>();

    // Wait until progress and deck data is ready
    while (game.progress.isEmpty || game.deck.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (!mounted) return;

    // Fade transition to HomeScreen
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) => const HomeScreen(),
      transitionsBuilder: (context, animation, secondary, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/amagama_logo.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                'Amagama',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
