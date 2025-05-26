import 'package:flutter/foundation.dart';
import 'package:starknet_flutter/starknet_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class WalletService extends ChangeNotifier {
  bool _isConnected = false;
  String? _address;
  double _balance = 0.0;
  StarknetClient? _client;
  bool _isLoading = false;
  final String _abi = '''[
    {
      "name": "balanceOf",
      "type": "function",
      "inputs": [{"name": "account", "type": "felt"}],
      "outputs": [{"name": "balance", "type": "Uint256"}]
    }
  ]''';

  bool get isConnected => _isConnected;
  String? get address => _address;
  double get balance => _balance;
  bool get isLoading => _isLoading;

  WalletService() {
    _initializeClient();
  }

  void _initializeClient() {
    final nodeUrl = dotenv.env['STARKNET_NODE_URL'];
    final tokenAddress = dotenv.env['CASS_TOKEN_ADDRESS'];
    
    if (nodeUrl == null || tokenAddress == null) {
      throw Exception('Missing environment variables');
    }

    _client = StarknetClient(nodeUrl);
  }

  Future<void> connectWallet() async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      notifyListeners();

      // Request wallet connection using Argent X or Braavos
      final response = await _client!.requestAccounts();
      
      if (response.isEmpty) {
        throw Exception('No accounts found');
      }

      _address = response[0];
      _isConnected = true;
      await _updateBalance();
      
      // Save connection state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('walletConnected', true);
      await prefs.setString('walletAddress', _address!);
      
      notifyListeners();
    } catch (e) {
      _isConnected = false;
      _address = null;
      _balance = 0.0;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateBalance() async {
    if (!_isConnected || _client == null) return;

    try {
      final contract = await _client!.getContract(
        address: dotenv.env['CASS_TOKEN_ADDRESS']!,
        abi: _abi,
      );

      final result = await contract.call(
        function: 'balanceOf',
        inputs: [_address!],
      );

      if (result.isNotEmpty) {
        final balance = result[0] as BigInt;
        _balance = balance.toDouble() / BigInt.from(10).pow(18).toDouble(); // Convert from wei to CASS
        notifyListeners();
      }
    } catch (e) {
      print('Error updating balance: $e');
      _balance = 0.0;
      notifyListeners();
    }
  }

  Future<void> depositCASS(double amount) async {
    if (!_isConnected || _client == null) {
      throw Exception('Wallet not connected');
    }

    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Convert amount to wei
      final amountInWei = BigInt.from(amount * 1e18);

      // Create transaction
      final transaction = await _client!.executeTransaction(
        contractAddress: dotenv.env['CASS_TOKEN_ADDRESS']!,
        function: 'deposit',
        inputs: [amountInWei.toString()],
      );

      // Wait for transaction receipt
      final receipt = await _client!.getTransactionReceipt(transaction.transactionHash);
      if (receipt == null || !receipt.status) {
        throw Exception('Transaction failed');
      }

      await _updateBalance();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> withdrawCASS(double amount) async {
    if (!_isConnected || _client == null) {
      throw Exception('Wallet not connected');
    }

    if (amount > _balance) {
      throw Exception('Insufficient balance');
    }

    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Convert amount to wei
      final amountInWei = BigInt.from(amount * 1e18);

      // Create transaction
      final transaction = await _client!.executeTransaction(
        contractAddress: dotenv.env['CASS_TOKEN_ADDRESS']!,
        function: 'withdraw',
        inputs: [amountInWei.toString()],
      );

      // Wait for transaction receipt
      final receipt = await _client!.getTransactionReceipt(transaction.transactionHash);
      if (receipt == null || !receipt.status) {
        throw Exception('Transaction failed');
      }

      await _updateBalance();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> swapCASS(double amount, String targetToken) async {
    if (!_isConnected || _client == null) {
      throw Exception('Wallet not connected');
    }

    if (amount > _balance) {
      throw Exception('Insufficient balance');
    }

    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Convert amount to wei
      final amountInWei = BigInt.from(amount * 1e18);

      // Create swap transaction
      final transaction = await _client!.executeTransaction(
        contractAddress: dotenv.env['CASS_TOKEN_ADDRESS']!,
        function: 'swap',
        inputs: [amountInWei.toString(), targetToken],
      );

      // Wait for transaction receipt
      final receipt = await _client!.getTransactionReceipt(transaction.transactionHash);
      if (receipt == null || !receipt.status) {
        throw Exception('Transaction failed');
      }

      await _updateBalance();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _client?.dispose();
    super.dispose();
  }
}
