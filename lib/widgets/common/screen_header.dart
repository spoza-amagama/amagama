// 📄 lib/widgets/common/screen_header.dart
//
// 🧱 ScreenHeader — shared top-of-screen header.
//
// Used by:
// • HomeScreen  (title + logo only)
// • PlayScreen  (title + subtitle + cycles + sentence meta + back button)
// • SettingsScreen / ProgressScreen (title + optional back button)
//
// API is intentionally flexible so screens can pass only what they need.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class ScreenHeader extends StatelessWidget {
  /// Main title, e.g. "Amagama", "Play", "Settings"
  final String title;

  /// Whether to show the small app logo badge on the right.
  final bool showLogo;

  /// Optional subtitle (used on Play to show the current sentence text).
  final String? subtitle;

  /// Optional cycles done for the current sentence.
  final int? cyclesDone;

  /// Optional cycles target for the current sentence.
  final int? cyclesTarget;

  /// Optional current sentence number (1-based).
  final int? sentenceNumber;

  /// Optional total number of sentences.
  final int? totalSentences;

  /// Optional leading widget (typically a back button).
  final Widget? leadingAction;

  /// Optional trailing widgets (e.g. actions).
  final List<Widget>? trailingActions;

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
    this.trailingActions,
  });

  bool get _hasMetaRow =>
      (cyclesDone != null && cyclesTarget != null) ||
      (sentenceNumber != null && totalSentences != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AmagamaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopRow(context),
          if (subtitle != null) ...[
            const SizedBox(height: AmagamaSpacing.xs),
            _buildSubtitle(context),
          ],
          if (_hasMetaRow) ...[
            const SizedBox(height: AmagamaSpacing.xs),
            _buildMetaRow(context),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // TOP ROW — leading, title, logo / trailing
  // ─────────────────────────────────────────────────────────────
  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        if (leadingAction != null) ...[
          leadingAction!,
          const SizedBox(width: AmagamaSpacing.sm),
        ],
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AmagamaTypography.titleStyle.copyWith(
              fontSize: 28,
              color: AmagamaColors.textPrimary,
            ),
          ),
        ),
        if (trailingActions != null) ...trailingActions!,
        if (showLogo) ...[
          const SizedBox(width: AmagamaSpacing.sm),
          _LogoBadge(),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SUBTITLE — usually current sentence text on Play screen
  // ─────────────────────────────────────────────────────────────
  Widget _buildSubtitle(BuildContext context) {
    return Text(
      subtitle!,
      textAlign: TextAlign.left,
      style: AmagamaTypography.bodyStyle.copyWith(
        fontSize: 16,
        color: AmagamaColors.textSecondary,
        height: 1.3,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // META ROW — cycles + sentence position (if provided)
  // ─────────────────────────────────────────────────────────────
  Widget _buildMetaRow(BuildContext context) {
    final showCycles = cyclesDone != null && cyclesTarget != null;
    final showSentence = sentenceNumber != null && totalSentences != null;

    return Row(
      children: [
        if (showCycles) ...[
          Icon(
            Icons.school_rounded,
            size: 18,
            color: AmagamaColors.textSecondary.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 4),
          Text(
            '${cyclesDone!} / ${cyclesTarget!} cycles',
            style: AmagamaTypography.bodyStyle.copyWith(
              fontSize: 14,
              color: AmagamaColors.textSecondary,
            ),
          ),
        ],
        if (showCycles && showSentence) const SizedBox(width: 12),
        if (showSentence) ...[
          Icon(
            Icons.menu_book_rounded,
            size: 18,
            color: AmagamaColors.textSecondary.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 4),
          Text(
            'Sentence $sentenceNumber of $totalSentences',
            style: AmagamaTypography.bodyStyle.copyWith(
              fontSize: 14,
              color: AmagamaColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Small inline logo badge shown when [showLogo] is true.
// ─────────────────────────────────────────────────────────────

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AmagamaColors.secondary,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AmagamaColors.textPrimary.withValues(alpha: 0.16),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'A',
        style: AmagamaTypography.titleStyle.copyWith(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}