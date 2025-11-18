// 📄 lib/widgets/home/carousel_scale_wrapper.dart
//
// 🔍 CarouselScaleWrapper — scales a child based on its distance from
// the current page in the PageView.

import 'package:flutter/material.dart';

class CarouselScaleWrapper extends StatelessWidget {
  final PageController controller;
  final int index;
  final Widget child;

  const CarouselScaleWrapper({
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
        double scale = 1.0;

        if (controller.position.haveDimensions) {
          final offset = controller.page! - index;
          scale = (1 - (offset.abs() * 0.25)).clamp(0.80, 1.0);
        }

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
    );
  }
}