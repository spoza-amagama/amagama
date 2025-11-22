// 📄 lib/widgets/grownups/pin_entry/pin_entry_flow.dart
//
// PinEntryFlow
// -----------------------------------------------------------------------------
// State owner for the PIN-entry dialog flow.
//
// Responsibilities:
// • Holds the entered PIN input
// • Manages shake animation on error
// • Delegates UI to PinEntryBody (pure widget)
// • Validates PIN for creation or verification
// • Notifies caller via onComplete
// • Supports optional onFailedAttempt and Forgot PIN callback
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_entry_body.dart';

class PinEntryFlow extends StatefulWidget {
  final String title;

  /// If provided → PIN must match this value.
  final String? verifyAgainst;

  /// If true → success when 4 digits are entered (used for PIN creation).
  final bool enforceLengthOnly;

  /// Called when the PIN is correct (or valid in creation mode).
  final void Function(String pin) onComplete;

  /// Called when verification fails.
  final VoidCallback? onFailedAttempt;

  /// Whether to show the “Forgot PIN?” link.
  final bool showForgotPin;

  /// Callback when “Forgot PIN?” is tapped.
  final VoidCallback? onForgotPin;

  const PinEntryFlow({
    super.key,
    required this.title,
    required this.onComplete,
    this.verifyAgainst,
    this.enforceLengthOnly = false,
    this.onFailedAttempt,
    this.showForgotPin = false,
    this.onForgotPin,
  });

  @override
  State<PinEntryFlow> createState() => _PinEntryFlowState();
}

class _PinEntryFlowState extends State<PinEntryFlow>
    with SingleTickerProviderStateMixin {
  String _entered = "";
  bool _error = false;

  late final AnimationController _shake;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();

    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _shakeAnim = Tween<double>(begin: 0, end: 16)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shake);
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Submission + validation
  // ---------------------------------------------------------------------------

  void _submit() {
    final pin = _entered;

    // Creating a new PIN → only check length 4
    if (widget.enforceLengthOnly) {
      if (pin.length != 4) {
        _triggerErr();
        return;
      }
      widget.onComplete(pin);
      return;
    }

    // Verifying → must match verifyAgainst
    if (widget.verifyAgainst != null && pin != widget.verifyAgainst) {
      _triggerErr();
      return;
    }

    widget.onComplete(pin);
  }

  void _triggerErr() {
    widget.onFailedAttempt?.call();

    setState(() => _error = true);
    _shake.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        _error = false;
        _entered = "";
      });
    });
  }

  // ---------------------------------------------------------------------------
  // Input handling
  // ---------------------------------------------------------------------------

  void _addDigit(String d) {
    if (_entered.length == 4) return;

    setState(() => _entered += d);

    if (_entered.length == 4) {
      Future.delayed(const Duration(milliseconds: 100), _submit);
    }
  }

  void _backspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: _shakeAnim,
        builder: (_, child) => Transform.translate(
          offset: Offset(_error ? _shakeAnim.value : 0, 0),
          child: child,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: PinEntryBody(
            title: widget.title,
            filled: _entered.length,
            onDigit: _addDigit,
            onBackspace: _backspace,
            onCancel: () => Navigator.pop(context),
            showForgotPin: widget.showForgotPin,
            onForgotPin: widget.onForgotPin,
          ),
        ),
      ),
    );
  }
}
