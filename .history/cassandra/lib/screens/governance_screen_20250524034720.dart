import 'package:flutter/material.dart';
import '../services/starknet_service.dart';

class GovernanceScreen extends StatefulWidget {
  const GovernanceScreen({super.key});

  @override
  State<GovernanceScreen> createState() => _GovernanceScreenState();
}

class _GovernanceScreenState extends State<GovernanceScreen> {
  final _starknetService = StarkNetService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _proposals = [];
  Map<String, dynamic>? _stats;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final proposals = await _starknetService.getAllProposals();
      final stats = await _starknetService.getGovernanceStats();
      
      setState(() {
        _proposals = proposals;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createProposal() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const CreateProposalDialog(),
    );

    if (result != null) {
      try {
        setState(() {
          _isLoading = true;
          _error = '';
        });

        await _starknetService.createProposal(
          title: result['title']!,
          description: result['description']!,
          requiredStake: result['requiredStake']!,
        );

        await _loadData();
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _vote(int proposalId, bool vote) async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      await _starknetService.voteOnProposal(proposalId, vote);
      await _loadData();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Governance Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Governance Overview',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _StatRow(
                    label: 'Total Proposals',
                    value: _stats!['totalProposals'].toString(),
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Active Proposals',
                    value: _stats!['activeProposals'].toString(),
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Total Votes',
                    value: '${(BigInt.parse(_stats!['totalVotes']) / BigInt.from(1e18)).toString()} tokens',
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Total Voters',
                    value: _stats!['totalVoters'].toString(),
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Quorum',
                    value: '${(BigInt.parse(_stats!['quorum']) / BigInt.from(1e18)).toString()} tokens',
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Min Proposal Stake',
                    value: '${(BigInt.parse(_stats!['minProposalStake']) / BigInt.from(1e18)).toString()} tokens',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Proposals List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Proposals',
                style: theme.textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: _createProposal,
                icon: const Icon(Icons.add),
                label: const Text('New Proposal'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_proposals.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No proposals yet',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _proposals.length,
              itemBuilder: (context, index) {
                final proposal = _proposals[index];
                final yesVotes = BigInt.parse(proposal['yesVotes']);
                final noVotes = BigInt.parse(proposal['noVotes']);
                final totalVotes = yesVotes + noVotes;
                final yesPercentage = totalVotes > BigInt.zero
                    ? (yesVotes * BigInt.from(100) / totalVotes).toInt()
                    : 0;
                final noPercentage = 100 - yesPercentage;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                proposal['title'],
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            _ProposalStatusChip(status: proposal['status']),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(proposal['description']),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Yes: $yesPercentage%',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: yesPercentage / 100,
                                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.colorScheme.primary,
                                    ),
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
                                    'No: $noPercentage%',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: noPercentage / 100,
                                    backgroundColor: theme.colorScheme.error.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.colorScheme.error,
                                    ),
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
                              'Required Stake: ${(BigInt.parse(proposal['requiredStake']) / BigInt.from(1e18)).toString()} tokens',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              'Voting Power: ${(BigInt.parse(proposal['votingPower']) / BigInt.from(1e18)).toString()} tokens',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        if (proposal['status'] == 0) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _vote(proposal['id'], true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                  child: const Text('Vote Yes'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _vote(proposal['id'], false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                  child: const Text('Vote No'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _ProposalStatusChip extends StatelessWidget {
  final int status;

  const _ProposalStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String label;
    Color color;

    switch (status) {
      case 0:
        label = 'Active';
        color = theme.colorScheme.primary;
        break;
      case 1:
        label = 'Passed';
        color = Colors.green;
        break;
      case 2:
        label = 'Failed';
        color = theme.colorScheme.error;
        break;
      case 3:
        label = 'Executed';
        color = Colors.blue;
        break;
      default:
        label = 'Unknown';
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CreateProposalDialog extends StatefulWidget {
  const CreateProposalDialog({super.key});

  @override
  State<CreateProposalDialog> createState() => _CreateProposalDialogState();
}

class _CreateProposalDialogState extends State<CreateProposalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requiredStakeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requiredStakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Proposal'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requiredStakeController,
                decoration: const InputDecoration(
                  labelText: 'Required Stake (tokens)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter required stake';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'description': _descriptionController.text,
                'requiredStake': _requiredStakeController.text,
              });
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
} 