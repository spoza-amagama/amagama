// 📄 lib/widgets/home/trophy_chip.dart
//
// TrophyChip — compact trophy indicator chip for the Home screen.
// ------------------------------------------------------------
// • Shows a trophy icon + optional label
// • Used in home header, trophy rows, progress highlights
// • Pure presentation widget (no logic)
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class TrophyChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? background;
  final Color? iconColor;
  final Color? textColor;

  const TrophyChip({
    super.key,
    required this.label,
    this.icon = Icons.emoji_events_rounded,
    this.background,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: (background ?? AmagamaColors.surface).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor ?? AmagamaColors.textPrimary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AmagamaTypography.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: textColor ?? AmagamaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}