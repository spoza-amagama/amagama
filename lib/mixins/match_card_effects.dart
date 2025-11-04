// 📄 lib/mixins/match_card_effects.dart
import 'package:flutter/material.dart';

/// 💫 MatchCardEffects — reusable bounce animation logic for card widgets.
mixin MatchCardEffects<T extends StatefulWidget> on State<T> {
  late final AnimationController bounceController;
  late final Animation<double> bounceAnim;

  void initBounce(TickerProvider vsync) {
    bounceController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 250),
    );
    bounceAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: bounceController, curve: Curves.easeOutBack),
    );
  }

  void triggerBounce() {
    if (!mounted) return;
    bounceController.forward(from: 0).then((_) => bounceController.reverse());
  }

  @override
  void dispose() {
    bounceController.dispose();
    super.dispose();
  }
}
