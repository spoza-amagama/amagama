import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/index.dart';
import '../../data/index.dart';
import 'home_header.dart';
import 'home_carousel.dart';
import 'home_buttons.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final s = sentences[game.currentSentenceIndex];
    final isSmall = MediaQuery.of(context).size.height < 720;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeHeader(sentence: s.text, isSmall: isSmall, game: game),
                  HomeCarousel(game: game),
                  const HomeButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
