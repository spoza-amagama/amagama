// 📄 lib/screens/play_screen.dart
// 🎮 PlayScreen — orchestration only
// ----------------------------------------------------------
// Hosts controllers + completion dialog, delegates all UI to PlayLayout.
// Uses the play widgets barrel; does NOT import legacy PlayBody/ProgressMessage.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/data/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/widgets/sparkle_layer.dart';
import 'package:amagama/widgets/play/index.dart'; // ✅ barrel import only

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final GlobalKey<SparkleLayerState> _sparkleKey = GlobalKey<SparkleLayerState>();
  bool _showingDialog = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.9,
      upperBound: 1.05,
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) _controller.reverse();
        if (s == AnimationStatus.dismissed) _controller.forward();
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final text = sentences[game.currentSentenceIndex].text;

    // show completion dialog once when all cards matched
    if (game.deck.isNotEmpty &&
        game.deck.every((c) => c.isMatched) &&
        !_showingDialog) {
      _showingDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => CompletionDialog(
            onNext: () {
              Navigator.of(ctx).pop();
              game.jumpToSentence(game.currentSentenceIndex + 1);
              _showingDialog = false;
            },
            onRepeat: () {
              Navigator.of(ctx).pop();
              game.jumpToSentence(game.currentSentenceIndex);
              _showingDialog = false;
            },
          ),
        );
      });
    }

    return PlayLayout(
      sentenceText: text,
      controller: _controller,
      sparkleKey: _sparkleKey,
    );
  }
}
