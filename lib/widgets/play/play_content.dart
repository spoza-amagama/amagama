// 📄 lib/widgets/play/play_content.dart
//
// PlayContent — main body for the Play screen.
// ------------------------------------------------------------
// NOTE: This is a lightweight scaffolding wrapper. Replace the
// inner body with your existing gameplay layout when ready.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PlayContent extends StatelessWidget {
  const PlayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Play screen coming soon',
        style: AmagamaTypography.titleStyle.copyWith(
          color: AmagamaColors.textPrimary,
        ),
      ),
    );
  }
}
