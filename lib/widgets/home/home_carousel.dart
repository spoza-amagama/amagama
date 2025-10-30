import 'package:flutter/material.dart';
import '../../data/index.dart';
import '../../state/game_controller.dart';
import '../index.dart';

class HomeCarousel extends StatelessWidget {
  final GameController game;
  const HomeCarousel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SentenceCarousel(
        count: sentences.length,
        currentIndex: game.currentSentenceIndex,
        isUnlocked: game.isSentenceUnlocked,
        onTap: (i) => game.jumpToSentence(i),
        sentenceText: (i) => sentences[i].text,
      ),
    );
  }
}
