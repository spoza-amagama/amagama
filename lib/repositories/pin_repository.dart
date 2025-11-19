// 📄 lib/repositories/pin_repository.dart
//
// 🔐 PinRepository — handles persistent storage of parental PIN.
// Stored securely using SharedPreferences (not plain text in code).

import 'package:shared_preferences/shared_preferences.dart';

class PinRepository {
  static const _keyPin = 'parental_pin';

  Future<String?> loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPin);
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPin, pin);
  }

  Future<void> clearPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPin);
  }

  Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyPin);
  }
}