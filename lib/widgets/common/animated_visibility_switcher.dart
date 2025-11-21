// 📄 lib/widgets/common/index.dart
//
// Cross-fades and scales between two states based on [visible].
// Useful for swapping "loading" vs "content" or "empty" vs "data".

import 'package:flutter/material.dart';

class AnimatedVisibilitySwitcher extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Duration duration;

  const AnimatedVisibilitySwitcher({
    super.key,
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 220),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        final scale = Tween<double>(begin: 0.95, end: 1.0).animate(fade);
        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: child,
          ),
        );
      },
      child: visible
          ? KeyedSubtree(
              key: const ValueKey('visible-child'),
              child: child,
            )
          : const SizedBox.shrink(key: ValueKey('hidden')),
    );
  }
}