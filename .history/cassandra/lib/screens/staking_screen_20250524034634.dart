import 'package:flutter/material.dart';
import '../services/starknet_service.dart';

class StakingScreen extends StatefulWidget {
  const StakingScreen({super.key});

  @override
  State<StakingScreen> createState() => _StakingScreenState();
}

class _StakingScreenState extends State<StakingScreen> {
  final _starknetService = StarkNetService();
  bool _isLoading = true;
  Map<String, dynamic>? _stake;
  Map<String, dynamic>? _stats;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final stake = await _starknetService.getStake(_starknetService.userAddress ?? '');
      final stats = await _starknetService.getStakingStats();
      
      setState(() {
        _stake = stake;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _stake() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const StakeDialog(),
    );

    if (result != null) {
      try {
        setState(() {
          _isLoading = true;
          _error = '';
        });

        await _starknetService.stake(
          result['amount'],
          result['duration'],
        );

        await _loadData();
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _unstake() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      await _starknetService.unstake();
      await _loadData();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _claimRewards() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      await _starknetService.claimRewards();
      await _loadData();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Staking Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Staking Overview',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _StatRow(
                    label: 'Total Staked',
                    value: '${(BigInt.parse(_stats!['totalStaked']) / BigInt.from(1e18)).toString()} tokens',
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Total Stakers',
                    value: _stats!['totalStakers'].toString(),
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Average Stake',
                    value: '${(BigInt.parse(_stats!['averageStake']) / BigInt.from(1e18)).toString()} tokens',
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Total Rewards',
                    value: '${(BigInt.parse(_stats!['totalRewards']) / BigInt.from(1e18)).toString()} tokens',
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Current APY',
                    value: '${_stats!['currentApy']}%',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Staking Periods
          Text(
            'Staking Periods',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stats!['stakingPeriods'].length,
            itemBuilder: (context, index) {
              final period = _stats!['stakingPeriods'][index];
              return Card(
                child: ListTile(
                  title: Text('${period['duration']} days'),
                  trailing: Text(
                    '${period['apy']}% APY',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Current Stake
          if (_stake != null && _stake!['isActive']) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Stake',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _StatRow(
                      label: 'Amount',
                      value: '${(BigInt.parse(_stake!['amount']) / BigInt.from(1e18)).toString()} tokens',
                    ),
                    const SizedBox(height: 8),
                    _StatRow(
                      label: 'Start Time',
                      value: DateTime.fromMillisecondsSinceEpoch(
                        int.parse(_stake!['startTime']),
                      ).toString().split('.')[0],
                    ),
                    const SizedBox(height: 8),
                    _StatRow(
                      label: 'End Time',
                      value: DateTime.fromMillisecondsSinceEpoch(
                        int.parse(_stake!['endTime']),
                      ).toString().split('.')[0],
                    ),
                    const SizedBox(height: 8),
                    _StatRow(
                      label: 'APY',
                      value: '${_stake!['apy']}%',
                    ),
                    const SizedBox(height: 8),
                    _StatRow(
                      label: 'Total Rewards',
                      value: '${(BigInt.parse(_stake!['totalRewards']) / BigInt.from(1e18)).toString()} tokens',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _unstake,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                            ),
                            child: const Text('Unstake'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _claimRewards,
                            child: const Text('Claim Rewards'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  Text(
                    'No active stake',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _stake,
                    child: const Text('Start Staking'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class StakeDialog extends StatefulWidget {
  const StakeDialog({super.key});

  @override
  State<StakeDialog> createState() => _StakeDialogState();
}

class _StakeDialogState extends State<StakeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  int _selectedDuration = 30;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Stake Tokens'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (tokens)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedDuration,
              decoration: const InputDecoration(
                labelText: 'Duration (days)',
              ),
              items: const [
                DropdownMenuItem(value: 30, child: Text('30 days')),
                DropdownMenuItem(value: 90, child: Text('90 days')),
                DropdownMenuItem(value: 180, child: Text('180 days')),
                DropdownMenuItem(value: 365, child: Text('365 days')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDuration = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'amount': _amountController.text,
                'duration': _selectedDuration,
              });
            }
          },
          child: const Text('Stake'),
        ),
      ],
    );
  }
} 