import 'package:flutter/material.dart';
import 'package:cassandra/services/mock_data_service.dart';
import 'package:cassandra/models/stake.dart';
import 'package:intl/intl.dart';

class StakingScreen extends StatelessWidget {
  const StakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stakes = MockDataService.getUserStakes('alice');
    final stakingPool = MockDataService.getStakingPool();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStakingPoolCard(stakingPool),
            const SizedBox(height: 16),
            _buildStakeList(stakes),
            const SizedBox(height: 16),
            _buildStakeForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildStakingPoolCard(Map<String, dynamic> pool) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Staking Pool',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPoolStat('Total Staked', '${pool['totalStaked']} tokens'),
            _buildPoolStat('Total Rewards', '${pool['totalRewards']} tokens'),
            _buildPoolStat('Reward Rate', '${pool['rewardRate']}% per day'),
          ],
        ),
      ),
    );
  }

  Widget _buildPoolStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStakeList(List<Stake> stakes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Stakes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...stakes.map((stake) => _buildStakeCard(stake)),
      ],
    );
  }

  Widget _buildStakeCard(Stake stake) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${stake.amount} tokens',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStakeStatus(stake),
              ],
            ),
            const SizedBox(height: 16),
            _buildStakeInfo('Start Date', dateFormat.format(stake.startTime)),
            _buildStakeInfo('End Date', dateFormat.format(stake.endTime)),
            _buildStakeInfo('Last Claim', timeFormat.format(stake.lastClaimTime)),
            _buildStakeInfo('Total Rewards', '${stake.totalRewards} tokens'),
            const SizedBox(height: 16),
            if (stake.canClaim)
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement claim rewards
                },
                child: const Text('Claim Rewards'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStakeStatus(Stake stake) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: stake.isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        stake.isActive ? 'Active' : 'Completed',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildStakeInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildStakeForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Stake',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount (tokens)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Duration (days)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement stake
              },
              child: const Text('Stake'),
            ),
          ],
        ),
      ),
    );
  }
} 