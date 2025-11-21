// 📄 lib/widgets/play/loading_overlay.dart
//
// Simple full-screen loading overlay used when needed.

import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool visible;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.visible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;

    return Stack(
      children: [
        child,
        Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}