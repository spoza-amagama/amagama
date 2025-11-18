// 📄 lib/widgets/home/carousel_depth_wrapper.dart
//
// 🌀 CarouselDepthWrapper — adds a simple vertical parallax depth effect
// based on page offset.

import 'package:flutter/material.dart';

class CarouselDepthWrapper extends StatelessWidget {
  final PageController controller;
  final int index;
  final Widget child;

  const CarouselDepthWrapper({
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
        double depth = 0;

        if (controller.position.haveDimensions) {
          final offset = controller.page! - index;
          depth = offset * 40;
        }

        return Transform.translate(
          offset: Offset(0, depth),
          child: child,
        );
      },
    );
  }
}