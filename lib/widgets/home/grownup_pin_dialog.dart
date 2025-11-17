// 📄 lib/widgets/home/grownup_pin_dialog.dart
//
// 🔒 GrownUpPinDialog
// ------------------------------------------------------------
// A secure modal dialog prompting for the 4-digit parental PIN.
// Used to gate access to the Grown Ups screen.
//

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amagama/theme/index.dart';

class GrownUpPinDialog extends StatefulWidget {
  final bool isStandalone;

  const GrownUpPinDialog({
    super.key,
    this.isStandalone = false,
  });

  @override
  State<GrownUpPinDialog> createState() => _GrownUpPinDialogState();
}

class _GrownUpPinDialogState extends State<GrownUpPinDialog> {
  final TextEditingController _pinController = TextEditingController();
  String? _errorText;
  bool _obscure = true;
  String _storedPin = '1234';

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedPin = prefs.getString('grownup_pin') ?? '1234';
    });
  }

  void _checkPin() {
    final entered = _pinController.text.trim();
    if (entered == _storedPin) {
      Navigator.pop(context, true); // ✅ Access granted
    } else {
      setState(() {
        _errorText = 'Incorrect PIN. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFFF8E1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Enter Parental PIN',
        style: AmagamaTypography.sectionTitleStyle,
      ),
      content: TextField(
        controller: _pinController,
        keyboardType: TextInputType.number,
        obscureText: _obscure,
        maxLength: 4,
        decoration: InputDecoration(
          hintText: '4-digit PIN',
          counterText: '',
          errorText: _errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel',
            style: AmagamaTypography.buttonStyle.copyWith(
              color: Colors.brown,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _checkPin,
          icon: const Icon(Icons.lock_open, size: 18),
          label: Text('Enter',
            style: AmagamaTypography.buttonStyle.copyWith(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown.shade700,
            minimumSize: const Size(100, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}