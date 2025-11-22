// 📄 lib/widgets/home/sections/home_actions_section.dart
//
// HomeActionsSection — Play button + Grown Ups button row.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

import '../actions/play_button_centered.dart';
import '../actions/grownups_button.dart';

class HomeActionsSection extends StatelessWidget {
  const HomeActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PlayButtonCentered(),
        const SizedBox(height: 12),
        GrownUpsButton(),
        const SizedBox(height: AmagamaSpacing.lg),
      ],
    );
  }
}
