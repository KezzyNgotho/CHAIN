import 'package:flutter/material.dart';

class GovernancePage extends StatefulWidget {
  const GovernancePage({super.key});

  @override
  State<GovernancePage> createState() => _GovernancePageState();
}

class _GovernancePageState extends State<GovernancePage> {
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
                  'Governance',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    // TODO: Navigate to create proposal
                  },
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
                _GovernanceTab(
                  label: 'Active',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                  icon: Icons.how_to_vote,
                  color: theme.colorScheme.primary,
                ),
                _GovernanceTab(
                  label: 'History',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                  icon: Icons.history,
                  color: theme.colorScheme.secondary,
                ),
                _GovernanceTab(
                  label: 'My Votes',
                  selected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                  icon: Icons.person_outline,
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
        return _buildActiveProposals();
      case 1:
        return _buildProposalHistory();
      case 2:
        return _buildMyVotes();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActiveProposals() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Placeholder count
      itemBuilder: (context, index) {
        return _ProposalCard(
          title: 'Sample Proposal ${index + 1}',
          description: 'This is a sample proposal description...',
          votes: '1,234',
          timeLeft: '2d left',
          status: 'Active',
        );
      },
    );
  }

  Widget _buildProposalHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Placeholder count
      itemBuilder: (context, index) {
        return _ProposalCard(
          title: 'Historical Proposal ${index + 1}',
          description: 'This is a historical proposal...',
          votes: '2,345',
          timeLeft: 'Ended 5d ago',
          status: 'Completed',
        );
      },
    );
  }

  Widget _buildMyVotes() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Placeholder count
      itemBuilder: (context, index) {
        return _ProposalCard(
          title: 'My Vote ${index + 1}',
          description: 'This is a proposal I voted on...',
          votes: '3,456',
          timeLeft: 'Ended 3d ago',
          status: 'Voted',
        );
      },
    );
  }
}

class _GovernanceTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const _GovernanceTab({
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

class _ProposalCard extends StatelessWidget {
  final String title;
  final String description;
  final String votes;
  final String timeLeft;
  final String status;

  const _ProposalCard({
    required this.title,
    required this.description,
    required this.votes,
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
                Row(
                  children: [
                    Icon(
                      Icons.how_to_vote,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      votes,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: theme.colorScheme.secondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeLeft,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
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
          ],
        ),
      ),
    );
  }
}
