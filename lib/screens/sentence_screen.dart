// 📄 lib/screens/sentence_screen.dart
//
// 📖 Sentence Screen — unified header
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
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
            AppPageHeader(title: "Sentence"),
            Expanded(child: SentenceContent()),
          ],
        ),
      ),
    );
  }
}