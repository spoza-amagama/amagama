// 📄 lib/screens/sentence_screen.dart
//
// 📘 Sentence Review Screen — shows the current sentence and related info.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/amagama_header.dart';
import 'package:amagama/widgets/sentence/sentence_content.dart';

class SentenceScreen extends StatelessWidget {
  const SentenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AmagamaHeader(subtitle: 'Sentence'),
            SizedBox(height: AmagamaSpacing.sm),
            Expanded(
              child: SentenceContent(),
            ),
          ],
        ),
      ),
    );
  }
}