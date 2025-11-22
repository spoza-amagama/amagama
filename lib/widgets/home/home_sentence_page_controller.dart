// 📄 lib/widgets/home/home_sentence_page_controller.dart
// ------------------------------------------------------------
// HomeSentencePageController — manages PageController lifecycle.
//
// Provides a ready-to-use controller configured with viewportFraction
// and initial page. Keeps Stateful logic OUT of the carousel UI.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';

class HomeSentencePageController extends StatefulWidget {
  final Widget Function(PageController controller) builder;

  const HomeSentencePageController({
    super.key,
    required this.builder,
  });

  @override
  State<HomeSentencePageController> createState() =>
      _HomeSentencePageControllerState();
}

class _HomeSentencePageControllerState
    extends State<HomeSentencePageController> {
  PageController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final game = context.read<GameController>();
    final initial = game.sentences.viewSentence;

    _controller ??= PageController(
      viewportFraction: 0.78,
      initialPage: initial,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_controller!);
  }
}
