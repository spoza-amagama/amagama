// 📄 lib/widgets/home/trophy_chip.dart
//
// 🏅 TrophyChip — small badge-style trophy indicator.
// Supports custom icon and color for bronze/silver/gold.

import 'package:flutter/material.dart';

class TrophyChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool earned;

  const TrophyChip({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = earned ? color : Colors.grey.shade400;
    final textColor = earned ? Colors.brown.shade800 : Colors.grey.shade500;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
        ),
      ],
    );
  }
}
