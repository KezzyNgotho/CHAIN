import 'package:flutter/material.dart';
import '../services/starknet_service.dart';
import 'market_list_screen.dart';

class LoginScreen extends StatefulWidget {
  final StarkNetService starknetService;

  const LoginScreen({
    Key? key,
    required this.starknetService,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _privateKeyController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    if (_privateKeyController.text.isEmpty) {
      setState(() => errorMessage = 'Please enter your private key');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final success = await widget.starknetService
          .connectWallet(_privateKeyController.text);
      if (success) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MarketListScreen(
              starknetService: widget.starknetService,
            ),
          ),
        );
      } else {
        setState(() => errorMessage = 'Failed to connect wallet');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Prediction Market',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _privateKeyController,
              decoration: const InputDecoration(
                labelText: 'Private Key',
                hintText: 'Enter your private key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // TODO: Implement wallet creation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wallet creation coming soon!'),
                  ),
                );
              },
              child: const Text('Create New Wallet'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }
}
