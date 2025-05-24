import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Markets',
            icon: Icons.currency_exchange_rounded,
            color: theme.colorScheme.primary,
            onTap: () {
              // TODO: Navigate to Markets
            },
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Rewards',
            icon: Icons.card_giftcard_rounded,
            color: theme.colorScheme.secondary,
            onTap: () {
              // TODO: Navigate to Rewards
            },
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Leaderboard',
            icon: Icons.leaderboard_rounded,
            color: theme.colorScheme.tertiary,
            onTap: () {
              // TODO: Navigate to Leaderboard
            },
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Profile',
            icon: Icons.person_rounded,
            color: theme.colorScheme.primary,
            onTap: () {
              // TODO: Navigate to Profile
            },
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
