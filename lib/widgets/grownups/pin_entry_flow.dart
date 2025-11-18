// 📄 lib/widgets/grownups/pin_entry_flow.dart
//
// Reusable PIN entry flow using the shared keypad + dot UI.
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'pin_dots.dart';
import 'keypad.dart';

class PinEntryFlow extends StatefulWidget {
  final String title;
  final String? verifyAgainst;  // optional
  final String errorText;
  final bool enforceLengthOnly; // for new PIN
  final void Function(String pin) onComplete;

  const PinEntryFlow({
    super.key,
    required this.title,
    required this.errorText,
    required this.onComplete,
    this.verifyAgainst,
    this.enforceLengthOnly = false,
  });

  @override
  State<PinEntryFlow> createState() => _PinEntryFlowState();
}

class _PinEntryFlowState extends State<PinEntryFlow>
    with SingleTickerProviderStateMixin {

  String _entered = "";
  bool _isError = false;

  late AnimationController _shake;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 14)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shake);
  }

  void _submit() {
    final pin = _entered;

    if (widget.enforceLengthOnly) {
      if (pin.length != 4) {
        _triggerError();
        return;
      }
      widget.onComplete(pin);
      return;
    }

    if (widget.verifyAgainst != null && pin != widget.verifyAgainst) {
      _triggerError();
      return;
    }

    widget.onComplete(pin);
  }

  void _triggerError() {
    setState(() => _isError = true);
    _shake.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _isError = false;
        _entered = "";
      });
    });
  }

  void _addDigit(String d) {
    if (_entered.length >= 4) return;
    setState(() => _entered += d);

    if (_entered.length == 4) {
      Future.delayed(const Duration(milliseconds: 120), _submit);
    }
  }

  void _backspace() {
    if (_entered.isNotEmpty) {
      setState(() => _entered = _entered.substring(0, _entered.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _shakeAnim,
        builder: (_, child) => Transform.translate(
          offset: Offset(_isError ? _shakeAnim.value : 0, 0),
          child: child,
        ),
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.title,
              style: AmagamaTypography.sectionTitleStyle.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            PinDots(filled: _entered.length),

            const SizedBox(height: 26),

            GrownupsKeypad(
              onDigit: _addDigit,
              onBackspace: _backspace,
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => Navigator.pop(context, null),
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