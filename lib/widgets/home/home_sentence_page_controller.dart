// 📄 lib/widgets/home/home_sentence_page_controller.dart
// ------------------------------------------------------------
// HomeSentencePageController — supports infinite-loop carousels.
// ------------------------------------------------------------
// 🟢 FIXED:
// • no longer overrides initialPage
// • allows parent widget (carousel) to supply its own controller
// • maintains lifecycle without interfering with infinite scroll
// ------------------------------------------------------------

import 'package:flutter/material.dart';

class HomeSentencePageController extends StatefulWidget {
  final PageController Function() createController;
  final Widget Function(PageController controller) builder;

  const HomeSentencePageController({
    super.key,
    required this.createController,
    required this.builder,
  });

  @override
  State<HomeSentencePageController> createState() =>
      _HomeSentencePageControllerState();
}

class _HomeSentencePageControllerState
    extends State<HomeSentencePageController> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.createController();   // parent sets initialPage
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_controller);
  }
}