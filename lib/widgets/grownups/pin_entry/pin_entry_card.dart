// 📄 lib/widgets/grownups/pin_entry/pin_entry_card.dart
// PinEntryCard — rounded surface container for PIN dialog content.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinEntryCard extends StatelessWidget {
  final Widget child;

  const PinEntryCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      decoration: BoxDecoration(
        color: AmagamaColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.15),
          ),
        ],
      ),
      child: child,
    );
  }
}
