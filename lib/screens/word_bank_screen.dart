// 📄 lib/screens/word_bank_screen.dart
//
// WordBankScreen — shows all learned / unlocked words.
// ------------------------------------------------------------
// • Uses global AmagamaHeader with “Words” subtitle
// • Body provided by WordBankContent
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/amagama_header.dart';
import 'package:amagama/widgets/words/word_bank_content.dart';

class WordBankScreen extends StatelessWidget {
  const WordBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: const [
            AmagamaHeader(subtitle: 'Words'),
            const SizedBox(height: AmagamaSpacing.sm),
            const Expanded(child: WordBankContent()),
          ],
        ),
      ),
    );
  }
}
