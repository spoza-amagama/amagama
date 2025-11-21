// 📄 lib/services/pin_service.dart
//
// 🔐 PinService — loads, stores and validates the parental PIN.

import 'package:amagama/repositories/pin_repository.dart';

class PinService {
  final PinRepository _repo = PinRepository();

  String? _currentPin;
  String? get currentPin => _currentPin;

  // Initialise from storage
  Future<void> init() async {
    _currentPin = await _repo.loadPin();
  }

  // Set/update the PIN
  Future<void> setPin(String newPin) async {
    _currentPin = newPin;
    await _repo.savePin(newPin);
  }

  // Clear the PIN completely
  Future<void> reset() async {
    _currentPin = null;
    await _repo.clearPin();
  }

  // Validate entered PIN
  bool validate(String entered) {
    if (_currentPin == null) return false;
    return entered == _currentPin;
  }
}
