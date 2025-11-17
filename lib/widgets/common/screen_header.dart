// 📄 lib/widgets/common/screen_header.dart
//
// 🌍 Compact ScreenHeader shared across all screens.
// ------------------------------------------------------
// • Reduced vertical spacing
// • Smaller logo
// • Optional subtitle, cycles, sentence number
// • No use of withOpacity()

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  final bool showLogo;

  final int? cyclesDone;
  final int? cyclesTarget;

  final int? sentenceNumber;
  final int? totalSentences;

  final Widget? leadingAction;
  final Widget? trailingAction;

  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = false,
    this.cyclesDone,
    this.cyclesTarget,
    this.sentenceNumber,
    this.totalSentences,
    this.leadingAction,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // ✂️ Compressed padding for compact header
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.sm,
      ),
      child: Column(
        children: [
          // 🔙 leading + title + trailing row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leadingAction ?? const SizedBox(width: 24),
              Text(
                title,
                style: AmagamaTypography.titleStyle,
              ),
              trailingAction ?? const SizedBox(width: 24),
            ],
          ),

          const SizedBox(height: AmagamaSpacing.xs),

          // 🪶 Logo (optional)
          if (showLogo) ...[
            Image.asset(
              "assets/logo/amagama_logo.png",
              width: 52,
              height: 52,
            ),
            const SizedBox(height: AmagamaSpacing.xs),
          ],

          // Subtitle
          if (subtitle != null)
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AmagamaTypography.subtitleStyle,
            ),

          // Cycles progress text
          if (cyclesDone != null && cyclesTarget != null)
            Text(
              "Cycles: $cyclesDone / $cyclesTarget",
              style: AmagamaTypography.progressStyle,
            ),

          // Sentence number
          if (sentenceNumber != null && totalSentences != null)
            Text(
              "Sentence $sentenceNumber of $totalSentences",
              style: AmagamaTypography.progressStyle,
            ),

          const SizedBox(height: AmagamaSpacing.xs),

          Divider(
            height: 1,
            thickness: 1,
            color: AmagamaColors.primary.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}