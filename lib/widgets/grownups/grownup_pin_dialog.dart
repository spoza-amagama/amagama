// 📄 lib/widgets/grownups/grownup_pin_dialog.dart
//
// 🔒 GrownUpPinDialog — Version B (Extracted & Modular)
// ------------------------------------------------------------
// • Fully separated into widgets/grownups directory
// • Uses PinDots + GrownupsKeypad widgets
// • Shake animation on incorrect PIN
// • SharedPreferences-based PIN storage
// • Scroll-safe & responsive
//

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amagama/theme/index.dart';

// External widgets (extracted previously)
import 'pin_dots.dart';
import 'keypad.dart';

class GrownUpPinDialog extends StatefulWidget {
  const GrownUpPinDialog({super.key});

  @override
  State<GrownUpPinDialog> createState() => _GrownUpPinDialogState();
}

class _GrownUpPinDialogState extends State<GrownUpPinDialog>
    with SingleTickerProviderStateMixin {
  String _entered = "";
  String _storedPin = "1234";
  bool _isError = false;

  late AnimationController _shake;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _loadPin();

    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _shakeAnim = Tween<double>(begin: 0, end: 14)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shake);
  }

  Future<void> _loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    _storedPin = prefs.getString('grownup_pin') ?? '1234';
    setState(() {});
  }

  void _addDigit(String d) {
    if (_entered.length >= 4) return;

    setState(() => _entered += d);

    if (_entered.length == 4) {
      Future.delayed(const Duration(milliseconds: 120), _verifyPin);
    }
  }

  void _verifyPin() {
    if (_entered == _storedPin) {
      Navigator.pop(context, true);
      return;
    }

    // Wrong PIN
    setState(() => _isError = true);
    _shake.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _isError = false;
        _entered = "";
      });
    });
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

      // Apply shake animation
      child: AnimatedBuilder(
        animation: _shakeAnim,
        builder: (_, child) => Transform.translate(
          offset: Offset(_isError ? _shakeAnim.value : 0, 0),
          child: child,
        ),
        child: _dialogContent(),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAIN PIN DIALOG UI
  // ------------------------------------------------------------
  Widget _dialogContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      // Prevent overflow
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter Parental PIN",
              style: AmagamaTypography.sectionTitleStyle.copyWith(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              "This area is for grown ups only.",
              style: AmagamaTypography.bodyStyle.copyWith(fontSize: 15),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 22),

            /// ● ● ● ● visual PIN representation
            PinDots(filled: _entered.length),

            const SizedBox(height: 26),

            /// 3×4 numeric keypad
            GrownupsKeypad(
              onDigit: _addDigit,
              onBackspace: () {
                if (_entered.isNotEmpty) {
                  setState(() {
                    _entered =
                        _entered.substring(0, _entered.length - 1);
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Cancel",
                style: AmagamaTypography.buttonStyle.copyWith(
                  color: AmagamaColors.textSecondary,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}