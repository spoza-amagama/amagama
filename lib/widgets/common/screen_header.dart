// 📄 lib/widgets/common/screen_header.dart
//
// ScreenHeader — top-of-screen reusable header with:
// • title
// • optional subtitle
// • sentence number (X / Y)
// • cycles progress (X / Y)
// • optional leading/back button
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final bool showLogo;
  final String? subtitle;

  final int? cyclesDone;
  final int? cyclesTarget;
  final int? sentenceNumber;
  final int? totalSentences;

  final Widget? leadingAction;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.showLogo,
    this.subtitle,
    this.cyclesDone,
    this.cyclesTarget,
    this.sentenceNumber,
    this.totalSentences,
    this.leadingAction,
  });

  @override
  Widget build(BuildContext context) {
    final showSentenceInfo =
        sentenceNumber != null && totalSentences != null;

    final showCycleInfo =
        cyclesDone != null && cyclesTarget != null && cyclesTarget! > 0;

    return Padding(
      padding: const EdgeInsets.all(AmagamaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (leadingAction != null) leadingAction!,
              if (leadingAction != null) const SizedBox(width: 8),

              Text(
                title,
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: 26,
                  color: AmagamaColors.textPrimary,
                ),
              ),

              if (showLogo) ...[
                const SizedBox(width: 8),
                const Icon(Icons.auto_awesome, color: Colors.amber),
              ],

              const Spacer(),
            ],
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary,
              ),
            ),
          ],

          if (showSentenceInfo) ...[
            const SizedBox(height: 6),
            Text(
              'Sentence $sentenceNumber of $totalSentences',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary.withAlpha(230),
                fontSize: 13,
              ),
            ),
          ],

          if (showCycleInfo) ...[
            const SizedBox(height: 8),
            Text(
              'Cycles: ${cyclesDone!} / ${cyclesTarget!}',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary.withAlpha(230),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: (cyclesDone! / cyclesTarget!).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AmagamaColors.surface.withAlpha(130),
              color: AmagamaColors.secondary,
            ),
          ],
        ],
      ),
    );
  }
}