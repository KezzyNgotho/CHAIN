import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crypto/crypto.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:eth_sig_util/eth_sig_util.dart';
import 'dart:convert';

class WalletService extends ChangeNotifier {
  bool _isConnected = false;
  String? _address;
  double _balance = 0.0;
  Web3Client? _client;
  Credentials? _credentials;
  EthereumAddress? _tokenAddress;
  bool _isLoading = false;
  final String _abi = '''[
    {
      "constant": true,
      "inputs": [{"name": "_owner", "type": "address"}],
      "name": "balanceOf",
      "outputs": [{"name": "balance", "type": "uint256"}],
      "type": "function"
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
    final nodeUrl = dotenv.env['ETHEREUM_NODE_URL'];
    final tokenAddress = dotenv.env['CASS_TOKEN_ADDRESS'];
    
    if (nodeUrl == null || tokenAddress == null) {
      throw Exception('Missing environment variables');
    }

    _client = Web3Client(nodeUrl, http.Client());
    _tokenAddress = EthereumAddress.fromHex(tokenAddress);
  }

  Future<void> connectWallet() async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      notifyListeners();

      // Request wallet connection
      final response = await http.post(
        Uri.parse('${dotenv.env['ETHEREUM_NODE_URL']}/wallet/connect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'method': 'eth_requestAccounts',
          'params': [],
          'id': 1,
          'jsonrpc': '2.0',
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to connect wallet');
      }

      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw Exception(data['error']['message']);
      }

      final accounts = data['result'] as List;
      if (accounts.isEmpty) {
        throw Exception('No accounts found');
      }

      _address = accounts[0];
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

  Future<void> disconnectWallet() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      _isConnected = false;
      _address = null;
      _balance = 0.0;
      _credentials = null;

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

  Future<void> _updateBalance() async {
    if (!_isConnected || _client == null || _tokenAddress == null) return;

    try {
      final contract = DeployedContract(
        ContractAbi.fromJson(_abi, 'CASS'),
        _tokenAddress!,
      );

      final balanceOf = contract.function('balanceOf');
      final result = await _client!.call(
        contract: contract,
        function: balanceOf,
        params: [EthereumAddress.fromHex(_address!)],
      );

      if (result.isNotEmpty) {
        final balance = result[0] as BigInt;
        _balance = balance.toDouble() / BigInt.from(10).pow(18).toDouble(); // Convert from wei to ETH
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
      final amountInWei = BigInt.from(amount * pow(10, 18));

      // Create transaction
      final transaction = await _client!.sendTransaction(
        _credentials!,
        Transaction(
          to: _tokenAddress,
          from: EthereumAddress.fromHex(_address!),
          value: EtherAmount.fromBigInt(EtherUnit.wei, amountInWei),
        ),
        chainId: 1, // Mainnet
      );

      // Wait for transaction receipt
      final receipt = await _client!.getTransactionReceipt(transaction);
      if (receipt == null || !receipt.status!) {
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
      final amountInWei = BigInt.from(amount * pow(10, 18));

      // Create transaction
      final transaction = await _client!.sendTransaction(
        _credentials!,
        Transaction(
          to: _tokenAddress,
          from: EthereumAddress.fromHex(_address!),
          value: EtherAmount.fromBigInt(EtherUnit.wei, amountInWei),
        ),
        chainId: 1, // Mainnet
      );

      // Wait for transaction receipt
      final receipt = await _client!.getTransactionReceipt(transaction);
      if (receipt == null || !receipt.status!) {
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
      final amountInWei = BigInt.from(amount * pow(10, 18));

      // Create swap transaction
      final transaction = await _client!.sendTransaction(
        _credentials!,
        Transaction(
          to: _tokenAddress,
          from: EthereumAddress.fromHex(_address!),
          value: EtherAmount.fromBigInt(EtherUnit.wei, amountInWei),
        ),
        chainId: 1, // Mainnet
      );

      // Wait for transaction receipt
      final receipt = await _client!.getTransactionReceipt(transaction);
      if (receipt == null || !receipt.status!) {
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
