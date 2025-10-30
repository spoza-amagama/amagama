// /lib/screens/play_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/state/index.dart';
import 'package:amagama/widgets/sentence_header.dart';
import 'package:amagama/widgets/card_grid.dart';
import 'package:amagama/widgets/play_audio_manager.dart';
import 'package:amagama/widgets/sparkle_layer.dart'; // ✅ NEW import
import 'package:amagama/models/sentence.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  bool _showEndDialog = false;

  // --- Audio state ---
  String _currentWord = '';
  String _currentSentenceId = '';
  bool _shouldPlayWord = false;
  bool _shouldPlaySentence = false;

  // --- Sentence animation ---
  late AnimationController _sentencePulse;

  // --- ✨ Sparkles ---
  final GlobalKey<SparkleLayerState> _sparkleKey = GlobalKey(); // ✅

  @override
  void initState() {
    super.initState();

    _sentencePulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _sentencePulse.reverse();
      });

    // 🔊 Play sentence audio once page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final game = context.read<GameController>();
      final s = sentences[game.currentSentenceIndex];
      setState(() {
        _currentSentenceId = s.id.toString();
        _shouldPlaySentence = true;
      });
      _triggerSentencePulse();
    });
  }

  void _triggerSentencePulse() {
    if (!_sentencePulse.isAnimating) _sentencePulse.forward();
  }

  @override
  void dispose() {
    _sentencePulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final s = sentences[game.currentSentenceIndex];

    final allMatched =
        game.deck.isNotEmpty && game.deck.every((c) => c.isMatched);
    if (allMatched && !_showEndDialog) {
      _showEndDialog = true;
      _handleAllMatched(game, s);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Match the Words — Sentence ${game.currentSentenceIndex + 1}',
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFFFFC107),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              // 🟨 Animated sentence + sparkles layered above
              Stack(
                alignment: Alignment.center,
                children: [
                  SentenceHeader(
                    text: s.text,
                    controller: _sentencePulse,
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: SparkleLayer(key: _sparkleKey), // ✅
                    ),
                  ),
                ],
              ),

              Expanded(
                child: CardGrid(
                  onWordFlip: (word) {
                    setState(() {
                      _currentWord = word;
                      _shouldPlayWord = true;
                      _shouldPlaySentence = false;
                    });
                  },
                  onSentenceComplete: (sentenceId) {
                    setState(() {
                      _currentSentenceId = sentenceId;
                      _shouldPlaySentence = true;
                      _shouldPlayWord = false;
                    });

                    // ✨ Trigger sparkle burst
                    _sparkleKey.currentState?.triggerSparkles();

                    _triggerSentencePulse();
                  },
                ),
              ),
            ],
          ),

          // 🔊 Audio manager (handles playback queue)
          PlayAudioManager(
            currentWord: _currentWord,
            shouldPlayWord: _shouldPlayWord,
            currentSentenceId: _currentSentenceId,
            shouldPlaySentence: _shouldPlaySentence,
          ),
        ],
      ),
    );
  }

  Future<void> _handleAllMatched(GameController game, Sentence s) async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _currentSentenceId = s.id.toString();
      _shouldPlaySentence = true;
      _shouldPlayWord = false;
    });
    _triggerSentencePulse();

    if (!mounted) return;

    // ✨ Show sparkle celebration when dialog opens
    _sparkleKey.currentState?.triggerSparkles();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final msg =
            "You’ve completed Sentence ${game.currentSentenceIndex + 1}!";
        return AlertDialog(
          backgroundColor: const Color(0xFFFFECB3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(
            child: Text("🎉 Great job!",
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                s.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text("Next"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;
    setState(() => _showEndDialog = false);
    game.jumpToSentence(game.currentSentenceIndex);
  }
}
