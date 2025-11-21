// 📄 lib/screens/home_screen.dart
//
// 🏡 Home Screen — stable vertical layout, no double scrolling
// ------------------------------------------------------------
// • Header stays fixed
// • HomeContent scrolls internally (if needed)
// • Avoids overflow on small devices
// • Matches new Amagama UI patterns
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/home/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Amagama',
              showLogo: true,
            ),

            // HomeContent manages its own scroll behavior.
            Expanded(
              child: HomeContent(),
            ),
          ],
        ),
      ),
    );
  }
}