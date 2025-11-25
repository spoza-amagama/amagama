// 📄 lib/widgets/common/app_page_header.dart
//
// AppPageHeader — global header for all screens.
// ------------------------------------------------------------
// • Primary header: [logo] AMAGAMA [logo]
// • Optional subheader for screen title
// • Optional back button overlaid on the left
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class AppPageHeader extends StatelessWidget {
  final String? title;   // e.g. “Grown Ups”, “Settings”, “Home”
  final bool showBack;   // when true → show a back arrow

  const AppPageHeader({
    super.key,
    this.title,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.md,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ----------------------------------------------------
          // Centered logo + AMAGAMA + logo + optional subheader
          // ----------------------------------------------------
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/amagama_logo.png',
                    height: 42,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'AMAGAMA',
                    style: AmagamaTypography.titleStyle.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AmagamaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/logo/amagama_logo.png',
                    height: 42,
                  ),
                ],
              ),
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

          // ----------------------------------------------------
          // Back button (overlaid at left, doesn’t break centering)
          // ----------------------------------------------------
          if (showBack)
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AmagamaColors.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }
}