// 📄 lib/widgets/play/sentence_unlock_indicator.dart
//
// 🏆 SentenceUnlockIndicator — simple medals only
// ------------------------------------------------------------
// Removed padlock and any progress icons.

import 'package:flutter/material.dart';

class SentenceUnlockIndicator extends StatelessWidget {
  final int index;

  const SentenceUnlockIndicator({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _Medal(label: 'Bronze'),
        SizedBox(width: 16),
        _Medal(label: 'Silver'),
        SizedBox(width: 16),
        _Medal(label: 'Gold'),
      ],
    );
  }
}

class _Medal extends StatelessWidget {
  final String label;
  const _Medal({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.emoji_events, size: 24, color: Colors.grey),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
