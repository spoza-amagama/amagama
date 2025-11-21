// 📄 lib/screens/home_screen.dart
//
// 🏡 Home Screen — simplified, week-free version
// ------------------------------------------------------------
// • Fixed header (shows logo + title)
// • Body driven entirely by HomeContent
// • No week selection, no progress by week
// • Clean vertical layout, fully responsive
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

            // HomeContent is responsible for:
            // • showing the current sentence
            // • progress / badges (sentence-based, not week-based)
            // • play button
            // • optional parents button
            Expanded(
              child: HomeContent(),
            ),
          ],
        ),
      ),
    );
  }
}