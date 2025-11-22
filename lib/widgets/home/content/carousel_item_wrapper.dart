// 📄 carousel_item_wrapper.dart
// AnimatedScale wrapper applied to each carousel item.

import 'package:flutter/material.dart';

class CarouselAnimatedWrapper extends StatelessWidget {
  final bool isActive;
  final Widget child;

  const CarouselAnimatedWrapper({
    super.key,
    required this.isActive,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.0 : 0.88,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}
