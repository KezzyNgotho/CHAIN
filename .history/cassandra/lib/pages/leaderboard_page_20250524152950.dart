import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Time Range Selector
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _TimeRangeTab(
                  label: '24H',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                  color: theme.colorScheme.primary,
                ),
                _TimeRangeTab(
                  label: '7D',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                  color: theme.colorScheme.secondary,
                ),
                _TimeRangeTab(
                  label: '30D',
                  selected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                  color: theme.colorScheme.tertiary,
                ),
                _TimeRangeTab(
                  label: 'ALL',
                  selected: _selectedTab == 3,
                  onTap: () => setState(() => _selectedTab = 3),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          // Category Selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _CategoryTab(
                  label: 'Traders',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                  icon: Icons.currency_exchange,
                  color: theme.colorScheme.primary,
                ),
                _CategoryTab(
                  label: 'Stakers',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                  icon: Icons.account_balance_wallet,
                  color: theme.colorScheme.secondary,
                ),
                _CategoryTab(
                  label: 'Creators',
                  selected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                  icon: Icons.person,
                  color: theme.colorScheme.tertiary,
                ),
              ],
            ),
          ),
          // Leaderboard List
          Expanded(
            child: _buildLeaderboardList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Top 10
      itemBuilder: (context, index) {
        return _LeaderboardItem(
          rank: index + 1,
          username: 'User${index + 1}',
          score: '${(1000 - index * 100).toString()} STRK',
          change: index % 2 == 0 ? '+5.2%' : '-2.1%',
          isPositive: index % 2 == 0,
        );
      },
    );
  }
}

class _TimeRangeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _TimeRangeTab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? color : color.withOpacity(0.7),
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const _CategoryTab({
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

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String username;
  final String score;
  final String change;
  final bool isPositive;

  const _LeaderboardItem({
    required this.rank,
    required this.username,
    required this.score,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rank <= 3
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.surface.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  rank.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: rank <= 3
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    score,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Change
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isPositive
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                change,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
