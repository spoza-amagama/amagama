import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/state/index.dart';
import 'package:amagama/models/sentence.dart';
import 'package:amagama/widgets/sentence_header.dart';
import 'package:amagama/widgets/card_grid.dart';
import 'package:amagama/widgets/play_audio_manager.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  bool _showEndDialog = false;
  late AnimationController _sentencePulse;

  @override
  void initState() {
    super.initState();
    _sentencePulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _sentencePulse.reverse();
      });

    // Play intro sentence on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final game = context.read<GameController>();
      final sentence = sentences[game.currentSentenceIndex];
      context
          .read<PlayAudioManagerController>()
          .playSentence(sentence.id.toString());
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
    final sentence = sentences[game.currentSentenceIndex];

    // When all cards are matched
    final allMatched =
        game.deck.isNotEmpty && game.deck.every((c) => c.isMatched);
    if (allMatched && !_showEndDialog) {
      _showEndDialog = true;
      _handleAllMatched(game, sentence);
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
        children: [
          Column(
            children: [
              SentenceHeader(
                text: sentence.text,
                controller: _sentencePulse,
              ),
              Expanded(
                child: CardGrid(
                  onWordPlayed: (word) =>
                      context.read<PlayAudioManagerController>().playWord(word),
                  onSentenceComplete: (sentenceId) {
                    context
                        .read<PlayAudioManagerController>()
                        .playSentence(sentenceId);
                    _triggerSentencePulse();
                  },
                ),
              ),
            ],
          ),
          const PlayAudioManager(), // Persistent overlay audio controller
        ],
      ),
    );
  }

  Future<void> _handleAllMatched(GameController game, Sentence sentence) async {
    await Future.delayed(const Duration(milliseconds: 400));
    context
        .read<PlayAudioManagerController>()
        .playSentence(sentence.id.toString());
    _triggerSentencePulse();

    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final msg =
            "You’ve completed Sentence ${game.currentSentenceIndex + 1}!";
        return AlertDialog(
          backgroundColor: const Color(0xFFFFECB3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(
            child: Text(
              "🎉 Great job!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(sentence.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
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
