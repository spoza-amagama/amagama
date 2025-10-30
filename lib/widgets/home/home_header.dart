import 'package:flutter/material.dart';
import '../../state/game_controller.dart';
import 'home_trophies.dart';

class HomeHeader extends StatelessWidget {
  final String sentence;
  final bool isSmall;
  final GameController game;
  const HomeHeader({
    super.key,
    required this.sentence,
    required this.isSmall,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Image.asset(
          'assets/logo/amagama_logo.png',
          width: isSmall ? 80 : 100,
          height: isSmall ? 80 : 100,
        ),
        const SizedBox(height: 6),
        Text(
          'Your Sentence',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 18 : 20,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              sentence,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmall ? 16 : 18,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 6),
        HomeTrophies(game: game),
      ],
    );
  }
}
