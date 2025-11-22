// 📄 lib/widgets/grownups/pin_entry/pin_entry_dots.dart
//
// PinEntryDots — small wrapper around PinDots for PIN entry UI.

import 'package:flutter/material.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_dots.dart';

class PinEntryDots extends StatelessWidget {
  final int filled;

  const PinEntryDots({
    super.key,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return PinDots(filled: filled);
  }
}
