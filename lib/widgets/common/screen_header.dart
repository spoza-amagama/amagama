// 📄 lib/widgets/common/index.dart
//
// Reusable top-of-screen header with optional subtitle and progress info.

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
          if (sentenceNumber != null && totalSentences != null) ...[
            const SizedBox(height: 4),
            Text(
              'Sentence $sentenceNumber of $totalSentences',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary.withValues(alpha: 0.9),
                fontSize: 13,
              ),
            ),
          ],
          if (cyclesDone != null && cyclesTarget != null) ...[
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: cyclesTarget == 0
                  ? 0
                  : (cyclesDone! / cyclesTarget!).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor:
                  AmagamaColors.surface.withValues(alpha: 0.5),
              color: AmagamaColors.secondary,
            ),
          ],
        ],
      ),
    );
  }
}