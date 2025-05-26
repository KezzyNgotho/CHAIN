import 'package:flutter/material.dart';
import 'governance_page.dart';
import 'staking_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        children: [
          // Governance Section
          ListTile(
            leading:
                Icon(Icons.gavel_outlined, color: theme.colorScheme.primary),
            title: const Text('Governance'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GovernancePage()));
            },
          ),
          // Staking Section
          ListTile(
            leading: Icon(Icons.currency_exchange_outlined,
                color: theme.colorScheme.secondary),
            title: const Text('Staking'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const StakingPage()));
            },
          ),
          // Analytics Section
          ListTile(
            leading: Icon(Icons.analytics_outlined,
                color: theme.colorScheme.tertiary),
            title: const Text('Analytics'),
            onTap: () {
              // TODO: Navigate to Analytics
            },
          ),
          // Leaderboard Section
          ListTile(
            leading: Icon(Icons.leaderboard_outlined,
                color: theme.colorScheme.primary),
            title: const Text('Leaderboard'),
            onTap: () {
              // TODO: Navigate to Leaderboard
            },
          ),
          // Portfolio Section
          ListTile(
            leading: Icon(Icons.account_balance_wallet_outlined,
                color: theme.colorScheme.secondary),
            title: const Text('Portfolio'),
            onTap: () {
              // TODO: Navigate to Portfolio
            },
          ),
          // Rewards Section
          ListTile(
            leading: Icon(Icons.card_giftcard_outlined,
                color: theme.colorScheme.tertiary),
            title: const Text('Rewards'),
            onTap: () {
              // TODO: Navigate to Rewards
            },
          ),
          // Settings Section
          ListTile(
            leading:
                Icon(Icons.settings_outlined, color: theme.colorScheme.primary),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
