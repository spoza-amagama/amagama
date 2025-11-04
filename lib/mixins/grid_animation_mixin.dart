// 📄 lib/mixins/grid_animation_mixin.dart
import 'package:flutter/material.dart';

/// 🎞️ Provides animation utilities for MatchCardGrid
mixin GridAnimationMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  late final AnimationController bounceController;
  late final Animation<double> bounceAnim;

  void initGridAnimations() {
    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    bounceAnim = Tween<double>(begin: 1.0, end: 1.08)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(bounceController);
  }

  Future<void> triggerBounce() async {
    await bounceController.forward(from: 0);
    await bounceController.reverse();
  }

  void disposeGridAnimations() => bounceController.dispose();

  Future<void> triggerFadeOut(Function onComplete) async {
    await Future.delayed(const Duration(milliseconds: 700));
    onComplete();
  }
}
