import 'package:flutter/material.dart';
import '../../state/game_controller.dart';
import 'trophy_chip.dart';

class HomeTrophies extends StatelessWidget {
  final GameController game;
  const HomeTrophies({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final p = game.currentProg;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4,
        runSpacing: 4,
        children: [
          TrophyChip(label: 'Bronze', earned: p.trophyBronze, color: const Color(0xFFCD7F32)),
          TrophyChip(label: 'Silver', earned: p.trophySilver, color: const Color(0xFFC0C0C0)),
          TrophyChip(label: 'Gold', earned: p.trophyGold, color: const Color(0xFFFFD700)),
          Text(
            '(${p.cyclesCompleted}/${game.cyclesTarget})',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
