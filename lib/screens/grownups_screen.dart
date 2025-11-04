// 📄 lib/screens/grownups_screen.dart
//
// 👨‍👩‍👧 GrownUpsScreen — parental control center
// ------------------------------------------------------------
// Allows adults to:
// • Change or set a 4-digit parental PIN (stored persistently).
// • Adjust number of cycles required per sentence.
// • Reset all progress safely.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';

class GrownUpsScreen extends StatefulWidget {
  const GrownUpsScreen({super.key});

  @override
  State<GrownUpsScreen> createState() => _GrownUpsScreenState();
}

class _GrownUpsScreenState extends State<GrownUpsScreen> {
  final TextEditingController _currentPin = TextEditingController();
  final TextEditingController _newPin = TextEditingController();
  final TextEditingController _confirmPin = TextEditingController();

  String? _savedPin;
  String? _errorText;
  bool _pinVisible = false;
  int _selectedCycles = 4;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPin = prefs.getString('grownup_pin');
      _selectedCycles = prefs.getInt('cycle_target') ?? 4;
    });
  }

  Future<void> _savePin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('grownup_pin', newPin);
    setState(() => _savedPin = newPin);
  }

  Future<void> _saveCycleSetting(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cycle_target', value);
    if (mounted) {
      final game = context.read<GameController>();
      await game.setCyclesTarget(value);
    }
  }

  Future<void> _handleSavePin() async {
    final current = _currentPin.text.trim();
    final newPin = _newPin.text.trim();
    final confirm = _confirmPin.text.trim();

    // ✅ First-time setup
    if (_savedPin == null || _savedPin!.isEmpty) {
      if (newPin.length != 4 || int.tryParse(newPin) == null) {
        setState(() => _errorText = 'PIN must be exactly 4 digits.');
        return;
      }
      if (newPin != confirm) {
        setState(() => _errorText = 'New PINs do not match.');
        return;
      }
      await _savePin(newPin);
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN created successfully!')),
      );
      return;
    }

    // ✅ PIN change validation
    if (current != _savedPin) {
      setState(() => _errorText = 'Current PIN is incorrect.');
      return;
    }
    if (newPin.length != 4 || int.tryParse(newPin) == null) {
      setState(() => _errorText = 'PIN must be exactly 4 digits.');
      return;
    }
    if (newPin != confirm) {
      setState(() => _errorText = 'New PINs do not match.');
      return;
    }

    await _savePin(newPin);
    _clearFields();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN updated successfully!')),
    );
  }

  void _clearFields() {
    _currentPin.clear();
    _newPin.clear();
    _confirmPin.clear();
    setState(() => _errorText = null);
  }

  Future<void> _handleResetProgress() async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Reset All Progress?'),
            content: const Text(
              'This will erase all progress for every sentence.\nAre you sure?',
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm && mounted) {
      await context.read<GameController>().resetAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game progress reset successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grown Ups'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔢 CYCLES SETTING
              const Text(
                'Session Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Set how many times each sentence must be completed before advancing.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Center(
                child: DropdownButton<int>(
                  value: _selectedCycles,
                  items: List.generate(
                    6,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1} cycles'),
                    ),
                  ),
                  onChanged: (v) async {
                    if (v != null) {
                      setState(() => _selectedCycles = v);
                      await _saveCycleSetting(v);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Current cycles target: ${game.cyclesTarget}',
                  style: TextStyle(
                    color: Colors.brown.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(height: 40),

              // 🔐 PIN MANAGEMENT
              const Text(
                'Parental PIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_savedPin != null)
                TextField(
                  controller: _currentPin,
                  keyboardType: TextInputType.number,
                  obscureText: !_pinVisible,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'Current PIN',
                    counterText: '',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _pinVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _pinVisible = !_pinVisible),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _newPin,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'New PIN',
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPin,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'Confirm New PIN',
                  counterText: '',
                  border: const OutlineInputBorder(),
                  errorText: _errorText,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _handleSavePin,
                icon: const Icon(Icons.save),
                label: Text(_savedPin == null ? 'Set PIN' : 'Save New PIN'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 40),

              // 🔁 RESET ALL PROGRESS
              ElevatedButton.icon(
                onPressed: _handleResetProgress,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset All Progress'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPin.dispose();
    _newPin.dispose();
    _confirmPin.dispose();
    super.dispose();
  }
}
