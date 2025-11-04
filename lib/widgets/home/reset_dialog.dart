// 📄 lib/widgets/home/reset_dialog.dart
//
// 🔐 ResetDialog — protected reset confirmation for grown-ups
// ------------------------------------------------------------
// Reads the saved 4-digit PIN from SharedPreferences (default = 1234)
// before allowing progress reset.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';

class ResetDialog extends StatefulWidget {
  const ResetDialog({super.key});

  @override
  State<ResetDialog> createState() => _ResetDialogState();
}

class _ResetDialogState extends State<ResetDialog> {
  final TextEditingController _pinController = TextEditingController();
  String? _errorText;
  String _requiredPin = '1234'; // default

  @override
  void initState() {
    super.initState();
    _loadStoredPin();
  }

  Future<void> _loadStoredPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _requiredPin = prefs.getString('grownup_pin') ?? '1234';
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    final totalSentences = game.progress.length;
    final completedCount = game.progress
        .where((p) => p.cyclesCompleted >= game.cyclesTarget)
        .length;

    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.lock, color: Colors.red, size: 26),
          SizedBox(width: 8),
          Text('Grown Ups Only'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You’ve completed $completedCount of $totalSentences sentences.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade700,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Resetting will erase all progress and start the game from the beginning. '
              'To confirm, please enter the 4-digit grown-ups PIN below.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter PIN',
                counterText: '',
                errorText: _errorText,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.password_outlined),
              ),
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final enteredPin = _pinController.text.trim();
            if (enteredPin == _requiredPin) {
              Navigator.pop(context, true);
            } else {
              setState(() => _errorText = 'Incorrect PIN');
            }
          },
          icon: const Icon(Icons.delete_forever, size: 18),
          label: const Text('Reset'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
