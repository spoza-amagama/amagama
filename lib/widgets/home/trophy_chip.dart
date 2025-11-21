// 📄 lib/widgets/home/trophy_chip.dart
//
// 🏅 TrophyChip — hybrid badge-style trophy indicator.
//
// Supports two usage styles:
//
// 1) Legacy icon-based usage:
//    TrophyChip(
//      icon: Icons.emoji_events,
//      color: Colors.amber,
//      label: 'Gold',
//      earned: true,
//    );
//
// 2) Count + emoji usage (HomeTrophiesRow):
//    TrophyChip(
//      label: 'Gold',
//      count: gold,
//      emoji: '🥇',
//    );

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class TrophyChip extends StatelessWidget {
  // Hybrid API -----------------------------
  final IconData? icon;   // legacy mode
  final Color? color;     // legacy mode
  final String label;     // shared
  final bool? earned;     // legacy mode

  final int? count;       // count mode
  final String? emoji;    // count mode

  const TrophyChip({
    super.key,
    this.icon,
    this.color,
    required this.label,
    this.earned,
    this.count,
    this.emoji,
  });

  bool get _usesCountMode => count != null || emoji != null;

  @override
  Widget build(BuildContext context) {
    // Decide "earned" flag:
    final bool isEarned = earned ?? ((count ?? 0) > 0);

    if (_usesCountMode) {
      // -----------------------------------
      // MODE 2 — Emoji + count (Home row)
      // -----------------------------------
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AmagamaColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned
                ? AmagamaColors.textPrimary
                : Colors.grey.shade400,
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji ?? '',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 6),
            Text(
              '${count ?? 0}',
              style: AmagamaTypography.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: isEarned
                    ? AmagamaColors.textPrimary
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------
    // MODE 1 — Legacy icon + label chip
    // ---------------------------------------
    final iconColor =
        isEarned ? (color ?? AmagamaColors.warning) : Colors.grey.shade400;
    final textColor =
        isEarned ? AmagamaColors.textPrimary : Colors.grey.shade500;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Icon(icon, color: iconColor, size: 20),
        if (icon != null) const SizedBox(width: 4),
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