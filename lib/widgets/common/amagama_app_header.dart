// 📄 lib/widgets/common/amagama_app_header.dart
//
// AmagamaAppHeader — universal app header used on *all* screens.
// ------------------------------------------------------------
// ✔ Logo (assets/logo/amagama_logo.png)
// ✔ “Amagama” title
// ✔ Subtitle (screen-defined)
// ✔ Optional Back button
// ✔ Optional Sentence X/Y
// ✔ Optional Cycle X/Y
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class AmagamaAppHeader extends StatelessWidget {
  final String subtitle;
  final VoidCallback? onBack;

  final int? sentenceNumber;
  final int? totalSentences;

  final int? cyclesDone;
  final int? cyclesTarget;

  const AmagamaAppHeader({
    super.key,
    required this.subtitle,
    this.onBack,
    this.sentenceNumber,
    this.totalSentences,
    this.cyclesDone,
    this.cyclesTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---------------- Back Button Row ----------------
        Row(
          children: [
            if (onBack != null)
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: AmagamaColors.textPrimary,
                onPressed: onBack,
              )
            else
              const const SizedBox(width: 48),

            const Spacer(),

            const const SizedBox(width: 48),
          ],
        ),

        // ---------------- Logo ----------------
        Image.asset(
          'assets/logo/amagama_logo.png',
          height: 72,
        ),

        const const SizedBox(height: 8),

        // ---------------- Title ----------------
        Text(
          'Amagama',
          textAlign: TextAlign.center,
          style: AmagamaTypography.titleStyle.copyWith(
            fontSize: 28,
            color: AmagamaColors.textPrimary,
          ),
        ),

        const const SizedBox(height: 4),

        // ---------------- Subtitle ----------------
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AmagamaTypography.bodyStyle.copyWith(
            fontSize: 18,
            color: AmagamaColors.textSecondary,
          ),
        ),

        // ---------------- Sentence Indicator ----------------
        if (sentenceNumber != null && totalSentences != null) ...[
          const const SizedBox(height: 8),
          Text(
            'Sentence $sentenceNumber of $totalSentences',
            style: AmagamaTypography.bodyStyle.copyWith(
              color: AmagamaColors.textPrimary,
            ),
          ),
        ],

        // ---------------- Cycle Indicator ----------------
        if (cyclesDone != null && cyclesTarget != null) ...[
          const const SizedBox(height: 4),
          Text(
            'Cycle $cyclesDone of $cyclesTarget',
            style: AmagamaTypography.bodyStyle.copyWith(
              color: AmagamaColors.textSecondary,
            ),
          ),
        ],

        const const SizedBox(height: AmagamaSpacing.md),
      ],
    );
  }
}