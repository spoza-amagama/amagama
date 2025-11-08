// 📄 lib/screens/play_screen.dart
// Orchestrates a single gameplay round. Shows overlay only when busy.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/services/audio/audio_service.dart';
import 'package:amagama/widgets/play/play_app_bar.dart';
import 'package:amagama/widgets/play/play_layout.dart';
import 'package:amagama/widgets/play/completion_dialog.dart';
import 'package:amagama/widgets/play/loading_overlay.dart';
import 'package:amagama/widgets/sparkle_layer.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  final GlobalKey<SparkleLayerState> _sparkleKey = GlobalKey();
  bool _showEndDialog = false;
  bool _didSpeak = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _speakSentence() async {
    final game = context.read<GameController>();
    final audio = AudioService();
    final sentence = sentences[game.currentSentenceIndex];
    await Future.delayed(const Duration(milliseconds: 400));
    await audio.playSentence(sentence.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didSpeak) {
      _didSpeak = true;
      _speakSentence();
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final sentence = sentences[game.currentSentenceIndex];

    return Scaffold(
      appBar: const PlayAppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          PlayLayout(
            controller: _pulse,
            sparkleKey: _sparkleKey,
            sentenceText: sentence.text, // required by PlayLayout
          ),
          if (_showEndDialog)
            CompletionDialog(
              onNext: () {
                setState(() => _showEndDialog = false);
                game.jumpToSentence(game.currentSentenceIndex + 1);
              },
            ),
          // 🔧 show overlay ONLY when busy
          if (game.busy) const LoadingOverlay(),
        ],
      ),
    );
  }
}
