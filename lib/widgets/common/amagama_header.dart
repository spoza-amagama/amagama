// 📄 lib/widgets/common/amagama_header.dart
//
// Fixed top header used on ALL screens.
// Layout:
//   [ Logo ]  Amagama
//   [ Subtitle ]

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class AmagamaHeader extends StatelessWidget {
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  const AmagamaHeader({
    super.key,
    required this.subtitle,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: AmagamaColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              leading ?? const SizedBox(width: 48),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/amagama_logo.png',
                      height: 42,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Amagama',
                      style: AmagamaTypography.titleStyle.copyWith(
                        fontSize: 30,
                        color: AmagamaColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ?? const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AmagamaTypography.bodyStyle.copyWith(
              fontSize: 16,
              color: AmagamaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}