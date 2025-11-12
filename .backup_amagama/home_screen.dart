// 📄 lib/screens/home_screen.dart
//
// 🏡 African-themed HomeScreen for Amagama.
// ------------------------------------------------------------
// Uses AmagamaColors, AmagamaSpacing, and AmagamaTypography.
// Includes gradient background, themed app bar, and main content.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/home/home_background.dart' as bg;
import 'package:amagama/widgets/home/home_app_bar.dart';
import 'package:amagama/widgets/home/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AmagamaColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AmagamaColors.primary,
                AmagamaColors.secondary.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AmagamaColors.primary.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const HomeAppBar(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 🌅 African-themed animated gradient background
            const bg.HomeBackground(),
            // 🧩 Main content (logo, carousel, buttons, etc.)
            Padding(
              padding: const EdgeInsets.all(AmagamaSpacing.md),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AmagamaColors.background.withValues(alpha: 0.95),
                  borderRadius:
                      BorderRadius.circular(AmagamaSpacing.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AmagamaColors.secondary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const HomeContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
