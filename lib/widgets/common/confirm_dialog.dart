// 📄 lib/widgets/common/confirm_dialog.dart
// ------------------------------------------------------------
// ConfirmDialog — Shared confirmation dialog used across Amagama.
// Features:
// • Title + message
// • Confirm + cancel buttons
// • Optional destructive mode (red confirm button)
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final bool destructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Cancel',
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final confirmColor =
        destructive ? AmagamaColors.accent : AmagamaColors.primary;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        title,
        style: AmagamaTypography.titleStyle.copyWith(
          fontSize: 20,
          color: AmagamaColors.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: AmagamaTypography.bodyStyle.copyWith(
          color: AmagamaColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            cancelLabel,
            style: AmagamaTypography.bodyStyle.copyWith(
              color: AmagamaColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(
            confirmLabel,
            style: AmagamaTypography.bodyStyle.copyWith(
              color: confirmColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}