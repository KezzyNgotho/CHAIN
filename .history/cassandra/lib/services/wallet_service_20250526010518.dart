import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class WalletService extends ChangeNotifier {
  bool _isConnected = false;
  String? _address;
  double _balance = 0.0;
  bool _isLoading = false;
  String? _error;

  // Configuration values
  final String _nodeUrl =
      'https://starknet-mainnet.g.alchemy.com/v2/rrN6yHLj1JK_s-9hP1VmE';
  final String _tokenAddress =
      '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7';
  final String _alchemyApiKey = 'rrN6yHLj1JK_s-9hP1VmE';

  bool get isConnected => _isConnected;
  String? get address => _address;
  double get balance => _balance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  WalletService() {
    _initializeClient();
  }

  void _initializeClient() {
    try {
      _error = null;
      // Configuration is now directly in the code
      print('Wallet service initialized with:');
      print('Node URL: $_nodeUrl');
      print('Token Address: $_tokenAddress');
    } catch (e) {
      _error = 'Error initializing wallet service: $e';
      print(_error);
    }
  }

  Future<void> connectWallet() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Request Argent X wallet connection
      final response = await _requestArgentXConnection();

      if (response.isEmpty) {
        _error = 'No accounts found';
        throw Exception(_error);
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
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> disconnectWallet() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      _isConnected = false;
      _address = null;
      _balance = 0.0;

      // Clear saved connection state
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('walletConnected');
      await prefs.remove('walletAddress');

      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkSavedConnection() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final isConnected = prefs.getBool('walletConnected') ?? false;
      final savedAddress = prefs.getString('walletAddress');

      if (isConnected && savedAddress != null) {
        _isConnected = true;
        _address = savedAddress;
        await _updateBalance();
        notifyListeners();
      }
    } catch (e) {
      print('Error checking saved connection: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<String>> _requestArgentXConnection() async {
    try {
      // Check if Argent X is installed
      final uri = Uri.parse('argentx://connect');
      final canLaunch = await canLaunchUrl(uri);

      if (!canLaunch) {
        throw Exception(
            'Please install Argent X wallet from: https://www.argent.xyz/argent-x/');
      }

      // Launch Argent X deep link
      await launchUrl(uri);

      // For development/testing, return a mock address
      return [
        '0x1234567890123456789012345678901234567890123456789012345678901234'
      ];
    } catch (e) {
      if (e.toString().contains('not installed')) {
        throw Exception(
            'Please install Argent X wallet from: https://www.argent.xyz/argent-x/');
      }
      throw Exception('Failed to connect to Argent X: $e');
    }
  }

  Future<void> _updateBalance() async {
    if (!_isConnected) return;

    try {
      _error = null;
      // Call Starknet RPC to get balance
      final response = await http.post(
        Uri.parse(_nodeUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'starknet_call',
          'params': [
            {
              'contract_address': _tokenAddress,
              'entry_point_selector':
                  '0x2e4263afad30923c891518314c3c95dbe830a16874e8abc5777a9a1b202fea',
              'calldata': [_address!]
            },
            'latest'
          ],
          'id': 1
        }),
      );

      if (response.statusCode != 200) {
        _error = 'Failed to get balance: ${response.statusCode}';
        throw Exception(_error);
      }

      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        _error = data['error']['message'];
        throw Exception(_error);
      }

      final result = data['result'] as List;
      if (result.isNotEmpty) {
        final balance = BigInt.parse(result[0]);
        _balance = balance.toDouble() / BigInt.from(10).pow(18).toDouble();
        notifyListeners();
      }
    } catch (e) {
      print('Error updating balance: $e');
      _balance = 0.0;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> depositCASS(double amount) async {
    if (!_isConnected) {
      throw Exception('Wallet not connected');
    }

    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Convert amount to wei
      final amountInWei = BigInt.from(amount * 1e18);

      // Create transaction for Argent X
      final transaction = {
        'contract_address': _tokenAddress,
        'entry_point_selector':
            '0x2f0b3c5710379609eb8495bec5ce77a083b1d47d685a853061a440e8d85239',
        'calldata': [amountInWei.toString()]
      };

      // Launch Argent X for transaction signing
      final uri = Uri.parse('argentx://sign?tx=${jsonEncode(transaction)}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Argent X wallet not installed');
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
    if (!_isConnected) {
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

      // Create transaction for Argent X
      final transaction = {
        'contract_address': _tokenAddress,
        'entry_point_selector':
            '0x2f0b3c5710379609eb8495bec5ce77a083b1d47d685a853061a440e8d85239',
        'calldata': [amountInWei.toString()]
      };

      // Launch Argent X for transaction signing
      final uri = Uri.parse('argentx://sign?tx=${jsonEncode(transaction)}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Argent X wallet not installed');
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
    if (!_isConnected) {
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

      // Create transaction for Argent X
      final transaction = {
        'contract_address': _tokenAddress,
        'entry_point_selector':
            '0x2f0b3c5710379609eb8495bec5ce77a083b1d47d685a853061a440e8d85239',
        'calldata': [amountInWei.toString(), targetToken]
      };

      // Launch Argent X for transaction signing
      final uri = Uri.parse('argentx://sign?tx=${jsonEncode(transaction)}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Argent X wallet not installed');
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
    super.dispose();
  }
}
