import 'package:flutter/material.dart';
import 'package:starknet/starknet.dart';

class StakingPool extends StatefulWidget {
  const StakingPool({Key? key}) : super(key: key);

  @override
  State<StakingPool> createState() => _StakingPoolState();
}

class _StakingPoolState extends State<StakingPool> {
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isStaking = false;
  bool _isUnstaking = false;
  bool _isClaiming = false;
  Map<String, dynamic>? _stakeInfo;
  Map<String, dynamic>? _poolInfo;

  @override
  void initState() {
    super.initState();
    _loadStakeInfo();
    _loadPoolInfo();
  }

  Future<void> _loadStakeInfo() async {
    try {
      final userAddress = await _starknetService.getCurrentUserAddress();
      if (userAddress != null) {
        final stake = await _starknetService.getStake(userAddress);
        setState(() {
          _stakeInfo = stake;
        });
      }
    } catch (e) {
      print('Failed to load stake info: $e');
    }
  }

  Future<void> _loadPoolInfo() async {
    try {
      final pool = await _starknetService.getStakingPool();
      setState(() {
        _poolInfo = pool;
      });
    } catch (e) {
      print('Failed to load pool info: $e');
    }
  }

  Future<void> _stake() async {
    if (_isStaking) return;

    setState(() {
      _isStaking = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final duration = int.parse(_durationController.text);
      await _starknetService.stake(amount.toString(), duration);
      await _loadStakeInfo();
      await _loadPoolInfo();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Staked successfully')),
      );
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
    if (_isUnstaking) return;

    setState(() {
      _isUnstaking = true;
    });

    try {
      await _starknetService.unstake();
      await _loadStakeInfo();
      await _loadPoolInfo();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unstaked successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to unstake: $e')),
      );
    } finally {
      setState(() {
        _isUnstaking = false;
      });
    }
  }

  Future<void> _claimRewards() async {
    if (_isClaiming) return;

    setState(() {
      _isClaiming = true;
    });

    try {
      await _starknetService.claimRewards();
      await _loadStakeInfo();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rewards claimed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to claim rewards: $e')),
      );
    } finally {
      setState(() {
        _isClaiming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Staking Pool',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            if (_poolInfo != null) ...[
              Text('Total Staked: ${_poolInfo!['total_staked']}'),
              Text('Total Rewards: ${_poolInfo!['total_rewards']}'),
              Text('Reward Rate: ${_poolInfo!['reward_rate']}% per day'),
            ],
            SizedBox(height: 16),
            if (_stakeInfo != null && _stakeInfo!['is_active']) ...[
              Text('Your Stake: ${_stakeInfo!['amount']}'),
              Text('Start Time: ${_stakeInfo!['start_time']}'),
              Text('End Time: ${_stakeInfo!['end_time']}'),
              Text('Total Rewards: ${_stakeInfo!['total_rewards']}'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isUnstaking ? null : _unstake,
                    child: Text('Unstake'),
                  ),
                  ElevatedButton(
                    onPressed: _isClaiming ? null : _claimRewards,
                    child: Text('Claim Rewards'),
                  ),
                ],
              ),
            ] else ...[
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount to Stake',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isStaking ? null : _stake,
                child: Text('Stake'),
              ),
            ],
          ],
        ),
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
