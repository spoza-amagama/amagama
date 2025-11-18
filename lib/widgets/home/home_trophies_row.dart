// 📄 lib/widgets/home/home_trophies_row.dart
//
// Horizontally arranged global trophy counters
// with distinct Bronze / Silver / Gold colours.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'trophy_column.dart';

class HomeTrophiesRow extends StatelessWidget {
  final int bronze;
  final int silver;
  final int gold;

  const HomeTrophiesRow({
    super.key,
    required this.bronze,
    required this.silver,
    required this.gold,
  });

  // Distinct metal colours (active / inactive), no opacity.
  static const Color _bronzeActive = Color(0xFFB87333);   // rich bronze
  static const Color _bronzeInactive = Color(0xFFCFA27A); // softer bronze

  static const Color _silverActive = Color(0xFF9E9E9E);   // classic silver
  static const Color _silverInactive = Color(0xFFD0D0D0); // pale silver

  static const Color _goldActive = Color(0xFFF6C445);     // warm gold
  static const Color _goldInactive = Color(0xFFE5D29A);   // soft gold

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TrophyColumn(
          icon: Icons.emoji_events,
          color: bronze > 0 ? _bronzeActive : _bronzeInactive,
          label: "$bronze Bronze",
        ),
        const SizedBox(width: 24),
        TrophyColumn(
          icon: Icons.emoji_events,
          color: silver > 0 ? _silverActive : _silverInactive,
          label: "$silver Silver",
        ),
        const SizedBox(width: 24),
        TrophyColumn(
          icon: Icons.emoji_events,
          color: gold > 0 ? _goldActive : _goldInactive,
          label: "$gold Gold",
        ),
      ],
    );
  }
}