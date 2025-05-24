import 'package:flutter/material.dart';

class StakingPage extends StatefulWidget {
  const StakingPage({super.key});

  @override
  State<StakingPage> createState() => _StakingPageState();
}

class _StakingPageState extends State<StakingPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staking'),
      ),
      body: Column(
        children: [
          // Stats Overview
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.2),
                  theme.colorScheme.secondary.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Total Staked',
                  value: '1,234 STRK',
                  icon: Icons.account_balance_wallet,
                  color: theme.colorScheme.primary,
                ),
                _StatItem(
                  label: 'APY',
                  value: '12.5%',
                  icon: Icons.trending_up,
                  color: theme.colorScheme.secondary,
                ),
                _StatItem(
                  label: 'Rewards',
                  value: '123 STRK',
                  icon: Icons.card_giftcard,
                  color: theme.colorScheme.tertiary,
                ),
              ],
            ),
          ),
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _StakingTab(
                  label: 'Active',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                  icon: Icons.stacked_line_chart,
                  color: theme.colorScheme.primary,
                ),
                _StakingTab(
                  label: 'History',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                  icon: Icons.history,
                  color: theme.colorScheme.secondary,
                ),
                _StakingTab(
                  label: 'Rewards',
                  selected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                  icon: Icons.card_giftcard,
                  color: theme.colorScheme.tertiary,
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to stake screen
        },
        icon: const Icon(Icons.add),
        label: const Text('Stake'),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildActiveStakes();
      case 1:
        return _buildStakingHistory();
      case 2:
        return _buildRewards();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActiveStakes() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Placeholder count
      itemBuilder: (context, index) {
        return _StakeCard(
          title: 'Staking Pool ${index + 1}',
          amount: '500 STRK',
          apy: '15%',
          timeLeft: '30d left',
          status: 'Active',
        );
      },
    );
  }

  Widget _buildStakingHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Placeholder count
      itemBuilder: (context, index) {
        return _StakeCard(
          title: 'Historical Stake ${index + 1}',
          amount: '300 STRK',
          apy: '12%',
          timeLeft: 'Ended 5d ago',
          status: 'Completed',
        );
      },
    );
  }

  Widget _buildRewards() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Placeholder count
      itemBuilder: (context, index) {
        return _StakeCard(
          title: 'Reward ${index + 1}',
          amount: '50 STRK',
          apy: 'N/A',
          timeLeft: 'Claimed 2d ago',
          status: 'Claimed',
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

class _StakingTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const _StakingTab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? color : color.withOpacity(0.5),
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected ? color : color.withOpacity(0.7),
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StakeCard extends StatelessWidget {
  final String title;
  final String amount;
  final String apy;
  final String timeLeft;
  final String status;

  const _StakeCard({
    required this.title,
    required this.amount,
    required this.apy,
    required this.timeLeft,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      amount,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APY',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      apy,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time Left',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      timeLeft,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Handle action based on status
                  },
                  child: Text(
                    status == 'Active' ? 'Unstake' : 'View Details',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 