// 📄 lib/widgets/splash/animated_splash_screen.dart
//
// 🚀 AnimatedSplashScreen
// ------------------------------------------------------------
// • Shows Amagama logo animation
// • Adds centered title “AMAGAMA”
// • Adds subtitle: “A fun way to learn sight words”
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/routes/index.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // APP LOGO
              Image.asset(
                'assets/logo/amagama_logo.png',
                height: 110,
              ),

              const SizedBox(height: 24),

              // TITLE: AMAGAMA
              Text(
                'AMAGAMA',
                textAlign: TextAlign.center,
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AmagamaColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              // SUBTITLE
              Text(
                'A fun way to learn sight words',
                textAlign: TextAlign.center,
                style: AmagamaTypography.bodyStyle.copyWith(
                  fontSize: 18,
                  color: AmagamaColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}