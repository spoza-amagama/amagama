import 'package:flutter/material.dart';

class SentenceHeader extends StatelessWidget {
  final String text;
  final AnimationController controller;

  const SentenceHeader({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Transform.scale(
          scale: animation.value,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.brown.shade800,
                  ),
            ),
          ),
        );
      },
    );
  }
}
