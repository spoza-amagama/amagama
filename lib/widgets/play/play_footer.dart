// 📄 lib/widgets/play/play_footer.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PlayFooter extends StatelessWidget {
  final ValueNotifier<String> word;
  final ValueNotifier<String> sentenceNotifier;
  final ValueNotifier<bool> playWord;
  final ValueNotifier<bool> playSentence;

  const PlayFooter({
    super.key,
    required this.word,
    required this.sentenceNotifier,
    required this.playWord,
    required this.playSentence,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AmagamaSpacing.md),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: word,
            builder: (context, value, _) {
              return Text(
                value,
                style: AmagamaTypography.subtitleStyle,
              );
            },
          ),
        ],
      ),
    );
  }
}