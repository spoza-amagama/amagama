// 📄 lib/widgets/home/home_app_bar.dart
//
// 🧭 African-themed Amagama home app bar.
// Uses Amagama theme (colors, spacing, typography) and shared decorations.
// --------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AmagamaDecorations.appBar(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AmagamaSpacing.md,
            vertical: AmagamaSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amagama',
                style: AmagamaTypography.titleStyle.copyWith(
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                color: Colors.white,
                onPressed: () {
                  // TODO: Implement settings navigation
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}