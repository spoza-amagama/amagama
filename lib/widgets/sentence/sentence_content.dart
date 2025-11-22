// 📄 lib/widgets/sentence/sentence_content.dart
//
// SentenceContent — review / details UI for the current sentence.
// ------------------------------------------------------------
// Placeholder implementation to satisfy imports. Replace with
// your real sentence review layout when ready.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SentenceContent extends StatelessWidget {
  const SentenceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sentence review coming soon',
        style: AmagamaTypography.titleStyle.copyWith(
          color: AmagamaColors.textPrimary,
        ),
      ),
    );
  }
}
