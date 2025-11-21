// 📄 lib/utils/sentence_height.dart
//
// Simple heuristic for sentence card height on the Home screen.

import 'package:flutter/material.dart';

class SentenceHeight {
  static double of(BuildContext context, String text) {
    // Basic heuristic: longer sentences get a bit more height.
    final length = text.length;
    if (length < 40) return 120;
    if (length < 80) return 150;
    return 180;
  }
}