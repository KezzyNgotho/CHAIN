import 'package:flutter/material.dart';
import 'services/starknet_service.dart';

class ContractTester extends StatefulWidget {
  const ContractTester({super.key});

  @override
  State<ContractTester> createState() => _ContractTesterState();
}

class _ContractTesterState extends State<ContractTester> {
  final _starknetService = StarkNetService();
  final _privateKeyController = TextEditingController();
  final _questionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  String _status = '';

  @override
  void dispose() {
    _privateKeyController.dispose();
    _questionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _connectWallet() async {
    if (_privateKeyController.text.isEmpty) {
      setState(() => _status = 'Please enter a private key');
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Connecting wallet...';
    });

    try {
      await _starknetService.connectWallet(_privateKeyController.text);
      setState(
          () => _status = 'Wallet connected: ${_starknetService.userAddress}');
    } catch (e) {
      setState(() => _status = 'Error connecting wallet: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createMarket() async {
    if (_questionController.text.isEmpty) {
      setState(() => _status = 'Please enter a question');
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Creating market...';
    });

    try {
      final endTime = DateTime.now().add(const Duration(days: 7));
      final txHash = await _starknetService.createMarket(
        _questionController.text,
        'default', // category
        endTime.millisecondsSinceEpoch ~/ 1000,
      );
      setState(() => _status = 'Market created! Hash: $txHash');
    } catch (e) {
      setState(() => _status = 'Error creating market: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getMarkets() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading markets...';
    });

    try {
      final markets = await _starknetService.getMarkets();
      setState(() => _status = 'Found ${markets.length} markets');
    } catch (e) {
      setState(() => _status = 'Error loading markets: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Tester'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _privateKeyController,
              decoration: const InputDecoration(
                labelText: 'Private Key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _connectWallet,
              child: const Text('Connect Wallet'),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Market Question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _createMarket,
              child: const Text('Create Market'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _getMarkets,
              child: const Text('Get Markets'),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Text(
                _status,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
