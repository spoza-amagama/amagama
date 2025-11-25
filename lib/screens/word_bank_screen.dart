// 📄 lib/screens/word_bank_screen.dart
//
// 📚 Word Bank Screen — unified header
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
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
            AppPageHeader(title: "Word Bank"),
            Expanded(child: WordBankContent()),
          ],
        ),
      ),
    );
  }
}