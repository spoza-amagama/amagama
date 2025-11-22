// 📄 lib/widgets/words/word_bank_content.dart
//
// WordBankContent — shows all learned / unlocked words.
// ------------------------------------------------------------
// Placeholder implementation to satisfy imports. Replace with
// your full word bank UI when ready.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class WordBankContent extends StatelessWidget {
  const WordBankContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Word bank coming soon',
        style: AmagamaTypography.titleStyle.copyWith(
          color: AmagamaColors.textPrimary,
        ),
      ),
    );
  }
}
