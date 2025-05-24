import 'package:flutter/material.dart';
import 'package:cassandra/services/mock_data_service.dart';
import 'package:cassandra/models/user_profile.dart';
import 'package:cassandra/models/market.dart';
import 'package:cassandra/models/stake.dart';
import 'package:cassandra/models/proposal.dart';
import 'package:cassandra/models/curation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.getUserProfile('alice');
    final markets = MockDataService.getMarkets();
    final stakes = MockDataService.getUserStakes('alice');
    final proposals = MockDataService.getProposals();
    final curations = MockDataService.getCurations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 24),
            _buildStatsSection(user),
            const SizedBox(height: 24),
            _buildMarketsSection(markets),
            const SizedBox(height: 24),
            _buildStakesSection(stakes),
            const SizedBox(height: 24),
            _buildProposalsSection(proposals),
            const SizedBox(height: 24),
            _buildCurationsSection(curations),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(
                    user.username[0].toUpperCase(),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Reputation: ${user.reputation}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(UserProfile user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Total Predictions', '${user.totalPredictions}'),
            _buildStatRow(
                'Successful Predictions', '${user.successfulPredictions}'),
            _buildStatRow('Success Rate',
                '${(user.successfulPredictions / user.totalPredictions * 100).toStringAsFixed(1)}%'),
            _buildStatRow('Total Staked', '${user.totalStaked} tokens'),
            _buildStatRow('Total Rewards', '${user.totalRewards} tokens'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
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

  Widget _buildMarketsSection(List<Market> markets) {
    final userMarkets = markets.where((m) => m.creator.id == 'alice').toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Created Markets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...userMarkets.map((market) => _buildMarketItem(market)),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketItem(Market market) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            market.question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Staked: ${market.totalStaked} tokens',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStakesSection(List<Stake> stakes) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Stakes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...stakes
                .where((s) => s.isActive)
                .map((stake) => _buildStakeItem(stake)),
          ],
        ),
      ),
    );
  }

  Widget _buildStakeItem(Stake stake) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${stake.amount} tokens',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rewards: ${stake.totalRewards} tokens',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalsSection(List<Proposal> proposals) {
    final userProposals =
        proposals.where((p) => p.proposer.id == 'alice').toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Created Proposals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...userProposals.map((proposal) => _buildProposalItem(proposal)),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalItem(Proposal proposal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            proposal.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Status: ${_getProposalStatus(proposal.status)}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getProposalStatus(int status) {
    switch (status) {
      case 0:
        return 'Active';
      case 1:
        return 'Passed';
      case 2:
        return 'Failed';
      case 3:
        return 'Executed';
      default:
        return 'Unknown';
    }
  }

  Widget _buildCurationsSection(List<Curation> curations) {
    final userCurations =
        curations.where((c) => c.curator.id == 'alice').toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Curations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...userCurations.map((curation) => _buildCurationItem(curation)),
          ],
        ),
      ),
    );
  }

  Widget _buildCurationItem(Curation curation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${curation.contentType.toUpperCase()}: ${curation.contentId}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: index < curation.rating ? Colors.amber : Colors.grey,
                  size: 16,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '${curation.upvotes} upvotes',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
