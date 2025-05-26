import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService extends ChangeNotifier {
  bool _isConnected = false;
  String? _address;
  String? _balance;

  bool get isConnected => _isConnected;
  String? get address => _address;
  String? get balance => _balance;

  Future<void> connectWallet() async {
    try {
      // Simulate wallet connection
      _address = '0x1234...5678';
      _balance = '1.234';
      _isConnected = true;

      // Save connection state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wallet_address', _address!);

      notifyListeners();
    } catch (e) {
      debugPrint('Error connecting wallet: $e');
      rethrow;
    }
  }

  Future<void> disconnectWallet() async {
    _address = null;
    _balance = null;
    _isConnected = false;

    // Clear saved connection state
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wallet_address');

    notifyListeners();
  }

  Future<void> checkSavedConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('wallet_address');

    if (savedAddress != null) {
      try {
        _address = savedAddress;
        _isConnected = true;
        _balance = '1.234'; // Simulated balance
        notifyListeners();
      } catch (e) {
        debugPrint('Error restoring saved connection: $e');
        await disconnectWallet();
      }
    }
  }
}
