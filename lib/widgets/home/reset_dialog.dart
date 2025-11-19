// 📄 lib/widgets/home/reset_dialog.dart
//
// 🧼 ResetDialog — themed confirmation dialog for resetting all progress.
// Uses Amagama colors & typography and clean single-purpose layout.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class ResetDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ResetDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
        decoration: BoxDecoration(
          color: AmagamaColors.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔸 Title
            Text(
              'Reset Progress?',
              textAlign: TextAlign.center,
              style: AmagamaTypography.titleStyle.copyWith(
                fontSize: 28,
                color: AmagamaColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            // 🔸 Subtitle
            Text(
              'This will erase all trophies,\ncycles and sentence progress.',
              textAlign: TextAlign.center,
              style: AmagamaTypography.bodyStyle.copyWith(
                fontSize: 18,
                color: AmagamaColors.textSecondary,
              ),
            ),

            const SizedBox(height: 28),

            // 🔸 Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AmagamaTypography.bodyStyle.copyWith(
                      color: AmagamaColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                ),

                // Confirm Reset Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  child: Text(
                    'Reset',
                    style: AmagamaTypography.bodyStyle.copyWith(
                      color: AmagamaColors.accent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}