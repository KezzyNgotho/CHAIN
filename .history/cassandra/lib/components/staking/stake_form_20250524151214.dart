import 'package:flutter/material.dart';

class StakeForm extends StatefulWidget {
  final String poolId;
  final String minStake;
  final String maxStake;
  final String apy;

  const StakeForm({
    Key? key,
    required this.poolId,
    required this.minStake,
    required this.maxStake,
    required this.apy,
  }) : super(key: key);

  @override
  State<StakeForm> createState() => _StakeFormState();
}

class _StakeFormState extends State<StakeForm> {
  final _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _stake() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement staking functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stake successful')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stake: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'New Stake',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _stake,
                    child: Text('Stake'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
