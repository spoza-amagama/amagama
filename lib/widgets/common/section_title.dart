// 📄 lib/widgets/common/index.dart
//
// Small section title used for sub-headings in screens.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;

  const SectionTitle({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.only(
      left: AmagamaSpacing.md,
      right: AmagamaSpacing.md,
      top: AmagamaSpacing.sm,
      bottom: AmagamaSpacing.xs,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: AmagamaTypography.titleStyle.copyWith(
          fontSize: 18,
          color: AmagamaColors.textPrimary,
        ),
      ),
    );
  }
}