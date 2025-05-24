import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to rewards history
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Rewards Overview
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Rewards',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1,234.56 STRK',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatItem(
                      label: 'Total Earned',
                      value: '5,678.90 STRK',
                      icon: Icons.account_balance_wallet,
                      color: theme.colorScheme.primary,
                    ),
                    _StatItem(
                      label: 'Pending',
                      value: '234.56 STRK',
                      icon: Icons.pending_actions,
                      color: theme.colorScheme.secondary,
                    ),
                    _StatItem(
                      label: 'Next Reward',
                      value: 'In 2d',
                      icon: Icons.timer,
                      color: theme.colorScheme.tertiary,
                    ),
                  ],
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
                _RewardsTab(
                  label: 'Active',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                  icon: Icons.star,
                  color: theme.colorScheme.primary,
                ),
                _RewardsTab(
                  label: 'Completed',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                  icon: Icons.check_circle,
                  color: theme.colorScheme.secondary,
                ),
                _RewardsTab(
                  label: 'Upcoming',
                  selected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                  icon: Icons.upcoming,
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
          // TODO: Navigate to claim rewards
        },
        icon: const Icon(Icons.card_giftcard),
        label: const Text('Claim Rewards'),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildActiveRewards();
      case 1:
        return _buildCompletedRewards();
      case 2:
        return _buildUpcomingRewards();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActiveRewards() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return _RewardCard(
          title: 'Active Reward ${index + 1}',
          description: 'Complete tasks to earn rewards',
          amount: '${(index + 1) * 100} STRK',
          progress: (index + 1) * 0.2,
          timeLeft: '${(index + 1) * 2}d left',
          status: 'Active',
        );
      },
    );
  }

  Widget _buildCompletedRewards() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return _RewardCard(
          title: 'Completed Reward ${index + 1}',
          description: 'Reward completed successfully',
          amount: '${(index + 1) * 100} STRK',
          progress: 1.0,
          timeLeft: 'Completed ${index + 1}d ago',
          status: 'Completed',
        );
      },
    );
  }

  Widget _buildUpcomingRewards() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return _RewardCard(
          title: 'Upcoming Reward ${index + 1}',
          description: 'Reward will be available soon',
          amount: '${(index + 1) * 100} STRK',
          progress: 0.0,
          timeLeft: 'Starts in ${(index + 1) * 2}d',
          status: 'Upcoming',
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

class _RewardsTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const _RewardsTab({
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

class _RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final double progress;
  final String timeLeft;
  final String status;

  const _RewardCard({
    required this.title,
    required this.description,
    required this.amount,
    required this.progress,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  amount,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  timeLeft,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            if (status == 'Active')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle claim action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Claim Reward'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
