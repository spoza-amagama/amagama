// 📄 lib/widgets/grownups/confirm_dialog.dart
//
// ❓ showConfirmDialog — reusable yes/no dialog.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFFFF8E1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(title, style: AmagamaTypography.sectionTitleStyle),
      content: Text(message, style: AmagamaTypography.bodyStyle),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: AmagamaTypography.buttonStyle.copyWith(
              color: AmagamaColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Confirm',
            style: AmagamaTypography.buttonStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
