import 'package:flutter/material.dart';
import 'package:amagama/widgets/home/home_background.dart' as bg;
import 'package:amagama/widgets/home/home_app_bar.dart';
import 'package:amagama/widgets/home/home_content.dart';

/// 🏡 HomeScreen — orchestrates the full home view stack.
/// ------------------------------------------------------------
/// • Animated gradient background
/// • Centered responsive app bar
/// • Scrollable main content
/// • Single, clean build() function
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: HomeAppBar(), // ✅ now responsive & minimal
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 🌈 Animated gradient background
            bg.HomeBackground(),

            // 🧩 Main content (header + carousel + buttons)
            HomeContent(),
          ],
        ),
      ),
    );
  }
}
