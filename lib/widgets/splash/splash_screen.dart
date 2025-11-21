// 📄 lib/widgets/splash/splash_screen.dart
// SplashScreen — simple branded startup screen showing the Amagama logo.

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo/amagama_logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}