// 📄 lib/widgets/common/app_page_header.dart
//
// AppPageHeader — global header for all screens.
// ------------------------------------------------------------
// • Primary header: [logo] AMAGAMA [logo]
// • Optional subheader for screen title
// • Fully responsive, no withOpacity, single-responsibility
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class AppPageHeader extends StatelessWidget {
  final String? title; // e.g. “Grown Ups”, “Settings”, “Play”

  const AppPageHeader({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ------------------------------------------------------------
          // Logo — AMAGAMA — Logo
          // ------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/amagama_logo.png',
                height: 32,
              ),
              const SizedBox(width: 8),
              Text(
                'AMAGAMA',
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AmagamaColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/logo/amagama_logo.png',
                height: 32,
              ),
            ],
          ),

          // ------------------------------------------------------------
          // Subheader: screen title
          // ------------------------------------------------------------
          if (title != null) ...[
            const SizedBox(height: 6),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: AmagamaTypography.bodyStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AmagamaColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}