import 'package:flutter/material.dart';

mixin FlipAnimationMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  late final AnimationController flipController;
  late final Animation<double> flipAnim;

  void initFlipAnimation() {
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: flipController, curve: Curves.easeInOut),
    );
  }

  void updateFlip(bool isFaceUp) =>
      isFaceUp ? flipController.forward() : flipController.reverse();

  void disposeFlipAnimation() => flipController.dispose();

  Matrix4 buildFlipTransform(double angle) => Matrix4.identity()
    ..setEntry(3, 2, 0.001)
    ..rotateY(angle);
}