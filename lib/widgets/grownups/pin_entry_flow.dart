// 📄 lib/widgets/grownups/pin_entry_flow.dart
import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'pin_dots.dart';
import 'keypad.dart';

class PinEntryFlow extends StatefulWidget {
  final String title;
  final String? verifyAgainst;
  final bool enforceLengthOnly;
  final void Function(String pin) onComplete;

  const PinEntryFlow({
    super.key,
    required this.title,
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
  bool _error = false;

  late AnimationController _shake;
  late Animation<double> _shakeAnim;

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

  void _submit() {
    final pin = _entered;

    if (widget.enforceLengthOnly) {
      if (pin.length != 4) return _triggerErr();
      return widget.onComplete(pin);
    }

    if (widget.verifyAgainst != null && pin != widget.verifyAgainst) {
      return _triggerErr();
    }

    widget.onComplete(pin);
  }

  void _triggerErr() {
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

  void _addDigit(String d) {
    if (_entered.length == 4) return;

    setState(() => _entered += d);

    if (_entered.length == 4) {
      Future.delayed(const Duration(milliseconds: 100), _submit);
    }
  }

  void _back() {
    if (_entered.isNotEmpty) {
      setState(() => _entered = _entered.substring(0, _entered.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: _shakeAnim,
        builder: (_, child) => Transform.translate(
          offset: Offset(_error ? _shakeAnim.value : 0, 0),
          child: child,
        ),
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      decoration: BoxDecoration(
        color: AmagamaColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.15),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title,
              style: AmagamaTypography.titleStyle.copyWith(fontSize: 26)),
          const SizedBox(height: 24),
          PinDots(filled: _entered.length),
          const SizedBox(height: 28),
          GrownupsKeypad(
            onDigit: _addDigit,
            onBackspace: _back,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}