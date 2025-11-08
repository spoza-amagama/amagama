// 📄 lib/widgets/play/responsive_scale.dart
// 🧩 ResponsiveScale
// ----------------------------------------------------------
// Scales child widgets smoothly for smaller or larger screens.
// Keeps Play screen layouts readable on phones and tablets.

import 'package:flutter/material.dart';

class ResponsiveScale extends StatelessWidget {
  final Widget child;
  final double baseWidth;

  const ResponsiveScale({
    super.key,
    required this.child,
    this.baseWidth = 390, // baseline iPhone 13 width
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / baseWidth).clamp(0.85, 1.25);
    return Transform.scale(
      scale: scale,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}
