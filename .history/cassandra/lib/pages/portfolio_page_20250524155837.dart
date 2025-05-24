import 'package:flutter/material.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Portfolio',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    // TODO: Navigate to add asset
                  },
                ),
              ],
            ),
          ),
          // Portfolio Overview
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  'Total Value',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '12,345.67 STRK',
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
                      label: '24h Change',
                      value: '+5.2%',
                      isPositive: true,
                      color: Colors.green,
                    ),
                    _StatItem(
                      label: '7d Change',
                      value: '+12.5%',
                      isPositive: true,
                      color: Colors.green,
                    ),
                    _StatItem(
                      label: '30d Change',
                      value: '-2.1%',
                      isPositive: false,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Asset Distribution Chart
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('Asset Distribution Chart'),
            ),
          ),
          // Tab Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _PortfolioTab(
                  label: 'Assets',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                  icon: Icons.account_balance_wallet,
                  color: theme.colorScheme.primary,
                ),
                _PortfolioTab(
                  label: 'History',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                  icon: Icons.history,
                  color: theme.colorScheme.secondary,
                ),
                _PortfolioTab(
                  label: 'Activity',
                  selected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                  icon: Icons.notifications,
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
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildAssetsList();
      case 1:
        return _buildHistoryList();
      case 2:
        return _buildActivityList();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAssetsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return _AssetCard(
          name: 'Asset ${index + 1}',
          symbol: 'AST${index + 1}',
          amount: '${(index + 1) * 100}',
          value: '${(index + 1) * 1000} STRK',
          change: index % 2 == 0 ? '+5.2%' : '-2.1%',
          isPositive: index % 2 == 0,
        );
      },
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return _HistoryCard(
          type: index % 2 == 0 ? 'Buy' : 'Sell',
          asset: 'Asset ${index + 1}',
          amount: '${(index + 1) * 50}',
          value: '${(index + 1) * 500} STRK',
          date: '2024-03-${index + 1}',
        );
      },
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return _ActivityCard(
          type: index % 3 == 0
              ? 'Stake'
              : (index % 3 == 1 ? 'Reward' : 'Transfer'),
          description: 'Activity ${index + 1}',
          amount: '${(index + 1) * 25} STRK',
          date: '2024-03-${index + 1}',
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.isPositive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _PortfolioTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const _PortfolioTab({
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

class _AssetCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String amount;
  final String value;
  final String change;
  final bool isPositive;

  const _AssetCard({
    required this.name,
    required this.symbol,
    required this.amount,
    required this.value,
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
            // Asset Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol.substring(0, 1),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Asset Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$amount $symbol',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Value and Change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
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
                    color: isPositive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isPositive ? Colors.green : Colors.red,
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

class _HistoryCard extends StatelessWidget {
  final String type;
  final String asset;
  final String amount;
  final String value;
  final String date;

  const _HistoryCard({
    required this.type,
    required this.asset,
    required this.amount,
    required this.value,
    required this.date,
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
            // Type Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: type == 'Buy'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  type == 'Buy' ? Icons.add : Icons.remove,
                  color: type == 'Buy' ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Transaction Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$type $asset',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
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

class _ActivityCard extends StatelessWidget {
  final String type;
  final String description;
  final String amount;
  final String date;

  const _ActivityCard({
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
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
            // Type Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  type == 'Stake'
                      ? Icons.account_balance_wallet
                      : (type == 'Reward'
                          ? Icons.card_giftcard
                          : Icons.swap_horiz),
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Activity Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Amount and Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
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
