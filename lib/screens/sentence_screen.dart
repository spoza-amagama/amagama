// 📄 lib/screens/sentence_screen.dart
//
// SentenceScreen — review / details shell.
// ------------------------------------------------------------
// • Uses global AmagamaHeader with “Sentence” subtitle
// • Body provided by SentenceContent
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/amagama_header.dart';
import 'package:amagama/widgets/sentence/sentence_content.dart';

class SentenceScreen extends StatelessWidget {
  const SentenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: const [
            AmagamaHeader(subtitle: 'Sentence'),
            const SizedBox(height: AmagamaSpacing.sm),
            const Expanded(child: SentenceContent()),
          ],
        ),
      ),
    );
  }
}
