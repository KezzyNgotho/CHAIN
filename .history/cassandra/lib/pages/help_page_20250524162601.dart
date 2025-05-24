import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
        elevation: 0,
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for help topics...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    title: 'Contact Support',
                    icon: Icons.support_agent,
                    onTap: () {
                      // TODO: Navigate to support chat
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickActionCard(
                    title: 'Report Issue',
                    icon: Icons.bug_report,
                    onTap: () {
                      // TODO: Navigate to issue reporting
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _FAQCard(
              question: 'How do I create a new market?',
              answer:
                  'To create a new market, navigate to the Markets tab and tap the + button. Fill in the market details including the question, end time, and initial stake.',
            ),
            const SizedBox(height: 8),
            _FAQCard(
              question: 'How does liquidity provision work?',
              answer:
                  'Liquidity providers can stake their tokens in the liquidity pool to earn fees from market trades. The more liquidity you provide, the more fees you earn.',
            ),
            const SizedBox(height: 8),
            _FAQCard(
              question: 'What is the emergency mode?',
              answer:
                  'Emergency mode is a safety feature that can be activated by operators in case of critical issues. It temporarily restricts certain operations until the issue is resolved.',
            ),
            const SizedBox(height: 32),

            // Documentation
            Text(
              'Documentation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _DocumentationCard(
              title: 'Getting Started',
              subtitle: 'Learn the basics of using the platform',
              icon: Icons.school_outlined,
              onTap: () {
                // TODO: Navigate to getting started guide
              },
            ),
            const SizedBox(height: 8),
            _DocumentationCard(
              title: 'Market Creation Guide',
              subtitle: 'Detailed guide on creating and managing markets',
              icon: Icons.analytics_outlined,
              onTap: () {
                // TODO: Navigate to market creation guide
              },
            ),
            const SizedBox(height: 8),
            _DocumentationCard(
              title: 'Governance Guide',
              subtitle: 'Learn about proposal creation and voting',
              icon: Icons.how_to_vote_outlined,
              onTap: () {
                // TODO: Navigate to governance guide
              },
            ),
            const SizedBox(height: 8),
            _DocumentationCard(
              title: 'Security Best Practices',
              subtitle: 'Tips for keeping your account secure',
              icon: Icons.security_outlined,
              onTap: () {
                // TODO: Navigate to security guide
              },
            ),
            const SizedBox(height: 32),

            // Community
            Text(
              'Community',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _CommunityCard(
              title: 'Discord',
              subtitle: 'Join our community chat',
              icon: Icons.chat_outlined,
              onTap: () {
                // TODO: Open Discord link
              },
            ),
            const SizedBox(height: 8),
            _CommunityCard(
              title: 'Twitter',
              subtitle: 'Follow us for updates',
              icon: Icons.flutter_dash,
              onTap: () {
                // TODO: Open Twitter link
              },
            ),
            const SizedBox(height: 8),
            _CommunityCard(
              title: 'GitHub',
              subtitle: 'Contribute to the project',
              icon: Icons.code_outlined,
              onTap: () {
                // TODO: Open GitHub link
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQCard extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQCard({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ExpansionTile(
        title: Text(
          question,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _DocumentationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CommunityCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
