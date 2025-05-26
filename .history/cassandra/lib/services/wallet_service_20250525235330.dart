import 'package:flutter/material.dart';
import 'package:starknet_flutter/starknet_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService extends ChangeNotifier {
  final StarknetProvider _provider = StarknetProvider(
    rpcUrl:
        'https://starknet-mainnet.infura.io/v3/YOUR_INFURA_KEY', // Replace with your Infura key
  );

  StarknetAccount? _account;
  bool _isConnected = false;
  String? _address;
  String? _balance;

  bool get isConnected => _isConnected;
  String? get address => _address;
  String? get balance => _balance;
  StarknetAccount? get account => _account;

  Future<void> connectWallet() async {
    try {
      // Initialize wallet connector
      final connector = WalletConnector(
        provider: _provider,
        supportedWallets: [
          ArgentWallet(),
          BraavosWallet(),
          // Add more supported wallets as needed
        ],
      );

      // Connect to wallet
      final result = await connector.connect();
      if (result != null) {
        _account = result;
        _address = result.address;
        _isConnected = true;

        // Get balance
        await _updateBalance();

        // Save connection state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('wallet_address', _address!);

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error connecting wallet: $e');
      rethrow;
    }
  }

  Future<void> disconnectWallet() async {
    _account = null;
    _address = null;
    _balance = null;
    _isConnected = false;

    // Clear saved connection state
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wallet_address');

    notifyListeners();
  }

  Future<void> _updateBalance() async {
    if (_account != null) {
      try {
        final balance = await _provider.getBalance(_account!.address);
        _balance = balance.toString();
        notifyListeners();
      } catch (e) {
        debugPrint('Error updating balance: $e');
      }
    }
  }

  Future<void> checkSavedConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('wallet_address');

    if (savedAddress != null) {
      try {
        _address = savedAddress;
        _isConnected = true;
        await _updateBalance();
        notifyListeners();
      } catch (e) {
        debugPrint('Error restoring saved connection: $e');
        await disconnectWallet();
      }
    }
  }
}
