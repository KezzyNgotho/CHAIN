import 'package:flutter/material.dart';
import 'governance_page.dart';
import 'staking_page.dart';
import 'analytics_page.dart';
import 'leaderboard_page.dart';
import 'portfolio_page.dart';
import 'rewards_page.dart';
import '../widgets/custom_app_bar.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const GovernancePage(),
    const StakingPage(),
    const AnalyticsPage(),
    const LeaderboardPage(),
    const PortfolioPage(),
    const RewardsPage(),
  ];

  void _onPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: _getPageTitle(_selectedIndex),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Navigation Menu
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _MoreTab(
                    label: 'Governance',
                    selected: _selectedIndex == 0,
                    onTap: () => _onPageSelected(0),
                    icon: Icons.gavel_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  _MoreTab(
                    label: 'Staking',
                    selected: _selectedIndex == 1,
                    onTap: () => _onPageSelected(1),
                    icon: Icons.currency_exchange_outlined,
                    color: theme.colorScheme.secondary,
                  ),
                  _MoreTab(
                    label: 'Analytics',
                    selected: _selectedIndex == 2,
                    onTap: () => _onPageSelected(2),
                    icon: Icons.analytics_outlined,
                    color: theme.colorScheme.tertiary,
                  ),
                  _MoreTab(
                    label: 'Leaderboard',
                    selected: _selectedIndex == 3,
                    onTap: () => _onPageSelected(3),
                    icon: Icons.leaderboard_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  _MoreTab(
                    label: 'Portfolio',
                    selected: _selectedIndex == 4,
                    onTap: () => _onPageSelected(4),
                    icon: Icons.account_balance_wallet_outlined,
                    color: theme.colorScheme.secondary,
                  ),
                  _MoreTab(
                    label: 'Rewards',
                    selected: _selectedIndex == 5,
                    onTap: () => _onPageSelected(5),
                    icon: Icons.card_giftcard_outlined,
                    color: theme.colorScheme.tertiary,
                  ),
                ],
              ),
            ),
          ),
          // Content
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Governance';
      case 1:
        return 'Staking';
      case 2:
        return 'Analytics';
      case 3:
        return 'Leaderboard';
      case 4:
        return 'Portfolio';
      case 5:
        return 'Rewards';
      default:
        return 'More';
    }
  }
}

class _MoreTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const _MoreTab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? color : color.withOpacity(0.5),
                size: 18,
              ),
              const SizedBox(width: 8),
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
