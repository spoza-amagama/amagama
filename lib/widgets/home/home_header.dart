// 📄 lib/widgets/home/home_header.dart
//
// 🏆 HomeHeader — trophies + per-sentence progress bar.
// ------------------------------------------------------------
// • No extra "Amagama" title row
// • No "Sentence X/Y" here (that lives below the bar now)
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/state/game_controller.dart';

import 'home_trophies.dart';

class HomeHeader extends StatelessWidget {
  final GameController game;

  const HomeHeader({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    // The GameController is currently unused here, but kept to avoid
    // touching call sites. HomeTrophies reads from context directly.
    return const HomeTrophies();
  }
}