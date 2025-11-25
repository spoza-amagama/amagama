// 📄 lib/screens/game_over_screen.dart
//
// 🏁 Game Over Screen — unified header + content
// Uses AppPageHeader and the composite GameOverContent.
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/game_over/game_over_content.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: const [
            AppPageHeader(title: "Game Over"),
            Expanded(
              child: GameOverContent(), // ❗ NOT const-safe, correct usage
            ),
          ],
        ),
      ),
    );
  }
}