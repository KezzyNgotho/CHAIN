import 'package:flutter/material.dart';
import 'package:starknet/starknet.dart';
import '../../services/starknet_service.dart';

class StakeForm extends StatefulWidget {
  const StakeForm({Key? key}) : super(key: key);

  @override
  State<StakeForm> createState() => _StakeFormState();
}

class _StakeFormState extends State<StakeForm> {
  final StarkNetService _starknetService = StarkNetService();
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isStaking = false;
  Map<String, dynamic>? _stakingPool;
  Map<String, dynamic>? _userStake;

  @override
  void initState() {
    super.initState();
    _loadStakingData();
  }

  Future<void> _loadStakingData() async {
    try {
      final userAddress = await _starknetService.getCurrentUserAddress();
      if (userAddress != null) {
        _userStake = await _starknetService.getStake(userAddress);
      }
      _stakingPool = await _starknetService.getStakingPool();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load staking data: $e')),
      );
    }
  }

  Future<void> _stake() async {
    if (_isStaking) return;

    setState(() {
      _isStaking = true;
    });

    try {
      final userAddress = await _starknetService.getCurrentUserAddress();
      if (userAddress == null) {
        throw Exception('User not connected');
      }
      await _starknetService.stake(
        userAddress,
        _amountController.text,
        int.parse(_durationController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Staked successfully')),
      );
      _loadStakingData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stake: $e')),
      );
    } finally {
      setState(() {
        _isStaking = false;
      });
    }
  }

  Future<void> _unstake() async {
    try {
      await _starknetService.unstake();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unstaked successfully')),
      );
      _loadStakingData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to unstake: $e')),
      );
    }
  }

  Future<void> _claimRewards() async {
    try {
      await _starknetService.claimRewards();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rewards claimed successfully')),
      );
      _loadStakingData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to claim rewards: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_stakingPool != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Staking Pool',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text('Total Staked: ${_stakingPool!['total_staked']}'),
                    Text('Total Rewards: ${_stakingPool!['total_rewards']}'),
                    Text('Reward Rate: ${_stakingPool!['reward_rate']}'),
                    Text(
                      'Min Stake Duration: ${_stakingPool!['min_stake_duration']} days',
                    ),
                    Text(
                      'Max Stake Duration: ${_stakingPool!['max_stake_duration']} days',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
          if (_userStake != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Stake',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text('Amount: ${_userStake!['amount']}'),
                    Text('Start Time: ${_userStake!['start_time']}'),
                    Text('End Time: ${_userStake!['end_time']}'),
                    Text('Total Rewards: ${_userStake!['total_rewards']}'),
                    Text(
                        'Status: ${_userStake!['is_active'] ? 'Active' : 'Inactive'}'),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _unstake,
                          child: Text('Unstake'),
                        ),
                        ElevatedButton(
                          onPressed: _claimRewards,
                          child: Text('Claim Rewards'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
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
                  SizedBox(height: 16),
                  TextField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Duration (days)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isStaking ? null : _stake,
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
    _durationController.dispose();
    super.dispose();
  }
}
