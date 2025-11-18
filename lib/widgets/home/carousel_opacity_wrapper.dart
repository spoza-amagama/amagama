// 📄 lib/widgets/home/carousel_opacity_wrapper.dart
//
// 🌫️ CarouselOpacityWrapper — fades carousel items as they move away
// from the center page.

import 'package:flutter/material.dart';

class CarouselOpacityWrapper extends StatelessWidget {
  final PageController controller;
  final int index;
  final Widget child;

  const CarouselOpacityWrapper({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        double opacity = 1.0;

        if (controller.position.haveDimensions) {
          final offset = (controller.page! - index).abs();
          opacity = (1 - (offset * 0.6)).clamp(0.20, 1.0);
        }

        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
    );
  }
}