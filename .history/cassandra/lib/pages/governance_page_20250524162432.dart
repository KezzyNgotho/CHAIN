import 'package:flutter/material.dart';

class GovernancePage extends StatefulWidget {
  const GovernancePage({super.key});

  @override
  State<GovernancePage> createState() => _GovernancePageState();
}

class _GovernancePageState extends State<GovernancePage> {
  bool _isLoading = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _createProposal() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement proposal creation
      // await starkNetService.createProposal(
      //   _titleController.text,
      //   _descriptionController.text,
      //   int.parse(_durationController.text),
      // );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proposal created successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating proposal: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _voteOnProposal(String proposalId, bool vote) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement voting
      // await starkNetService.vote(proposalId, vote);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vote recorded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error recording vote: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
        elevation: 0,
        title: const Text('Governance'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateProposalDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Governance Stats
            Container(
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
                    'Governance Stats',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(
                        label: 'Total Proposals',
                        value: '12',
                        icon: Icons.description,
                        color: theme.colorScheme.primary,
                      ),
                      _StatItem(
                        label: 'Active Proposals',
                        value: '3',
                        icon: Icons.how_to_vote,
                        color: theme.colorScheme.secondary,
                      ),
                      _StatItem(
                        label: 'Your Voting Power',
                        value: '1,234 STRK',
                        icon: Icons.power,
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Active Proposals
            Text(
              'Active Proposals',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _ProposalCard(
              title: 'Increase Market Creation Rate Limit',
              description: 'Proposal to increase the market creation rate limit from 5 to 10 per hour.',
              endTime: DateTime.now().add(const Duration(days: 2)),
              votesFor: 1234,
              votesAgainst: 567,
              onVote: (vote) => _voteOnProposal('1', vote),
            ),
            const SizedBox(height: 8),
            _ProposalCard(
              title: 'Update Emergency Threshold',
              description: 'Proposal to update the emergency threshold from 3 to 4 operators.',
              endTime: DateTime.now().add(const Duration(days: 5)),
              votesFor: 890,
              votesAgainst: 123,
              onVote: (vote) => _voteOnProposal('2', vote),
            ),
            const SizedBox(height: 8),
            _ProposalCard(
              title: 'Add New Market Category',
              description: 'Proposal to add a new market category for sports events.',
              endTime: DateTime.now().add(const Duration(days: 7)),
              votesFor: 2345,
              votesAgainst: 789,
              onVote: (vote) => _voteOnProposal('3', vote),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateProposalDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Proposal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter proposal title',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter proposal description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (days)',
                  hintText: 'Enter voting duration in days',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _createProposal,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Create'),
          ),
        ],
      ),
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

class _ProposalCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime endTime;
  final int votesFor;
  final int votesAgainst;
  final Function(bool) onVote;

  const _ProposalCard({
    required this.title,
    required this.description,
    required this.endTime,
    required this.votesFor,
    required this.votesAgainst,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalVotes = votesFor + votesAgainst;
    final forPercentage = totalVotes > 0 ? (votesFor / totalVotes * 100) : 0;
    final againstPercentage = totalVotes > 0 ? (votesAgainst / totalVotes * 100) : 0;

    return Card(
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'For: ${forPercentage.toStringAsFixed(1)}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: forPercentage / 100,
                        backgroundColor: Colors.green.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Against: ${againstPercentage.toStringAsFixed(1)}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: againstPercentage / 100,
                        backgroundColor: Colors.red.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ends: ${endTime.toString().split('.')[0]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => onVote(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('For'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => onVote(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Against'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
