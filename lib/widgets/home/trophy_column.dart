// 📄 lib/widgets/home/trophy_column.dart
//
// Smaller trophy pill for tighter vertical layout.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class TrophyColumn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const TrophyColumn({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔽 Smaller pill (58 px)
        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF4C8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE8D8A0),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,    // 🔽 reduced from 38
          ),
        ),

        const SizedBox(height: 6), // 🔽 tighter gap

        Text(
          label,
          style: AmagamaTypography.smallLabelStyle.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}