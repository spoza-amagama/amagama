// 📄 lib/screens/word_bank_screen.dart
//
// 🔤 Word Bank Screen — shows all learnt words with audio.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/amagama_header.dart';
import 'package:amagama/widgets/words/word_bank_content.dart';

class WordBankScreen extends StatelessWidget {
  const WordBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AmagamaHeader(subtitle: 'Words'),
            SizedBox(height: AmagamaSpacing.sm),
            Expanded(
              child: WordBankContent(),
            ),
          ],
        ),
      ),
    );
  }
}