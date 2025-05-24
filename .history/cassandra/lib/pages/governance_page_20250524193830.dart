import 'package:flutter/material.dart';
import '../main.dart';
import 'notifications_page.dart';
import 'help_page.dart';

class GovernancePage extends StatelessWidget {
  const GovernancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Governance',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Your Voting Power',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        label: 'STRK',
                        value: '1,234',
                      ),
                      _StatItem(
                        label: 'Votes',
                        value: '45',
                      ),
                      _StatItem(
                        label: 'Proposals',
                        value: '3',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Active Proposals
          const Text(
            'Active Proposals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.how_to_vote, color: Colors.white),
              ),
              title: const Text('Increase Market Fee'),
              subtitle: const Text('Ends in 3 days'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Proposal Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Increase market fee from 0.1% to 0.2%'),
                        SizedBox(height: 16),
                        Text('Current Votes:'),
                        Text('• Yes: 2,345'),
                        Text('• No: 1,234'),
                        Text('• Abstain: 123'),
                        SizedBox(height: 16),
                        Text('Required: 5,000 votes'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => UniversalDialog(
                              title: 'Cast Vote',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('How would you like to vote?'),
                                  SizedBox(height: 16),
                                  Text('• Yes'),
                                  Text('• No'),
                                  Text('• Abstain'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      UniversalSnackBar(
                                        message: 'Vote cast successfully',
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text('Vote'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Vote'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.add_circle, color: Colors.white),
              ),
              title: const Text('Add New Market'),
              subtitle: const Text('Ends in 5 days'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Proposal Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Add new market for ETH/USD price prediction'),
                        SizedBox(height: 16),
                        Text('Current Votes:'),
                        Text('• Yes: 3,456'),
                        Text('• No: 2,345'),
                        Text('• Abstain: 234'),
                        SizedBox(height: 16),
                        Text('Required: 5,000 votes'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => UniversalDialog(
                              title: 'Cast Vote',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('How would you like to vote?'),
                                  SizedBox(height: 16),
                                  Text('• Yes'),
                                  Text('• No'),
                                  Text('• Abstain'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      UniversalSnackBar(
                                        message: 'Vote cast successfully',
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text('Vote'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Vote'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Create Proposal
          const Text(
            'Create Proposal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: const Text('New Proposal'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Create Proposal',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Proposal Details'),
                        SizedBox(height: 16),
                        Text('• Title'),
                        Text('• Description'),
                        Text('• Duration'),
                        Text('• Required Votes'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            UniversalSnackBar(
                              message: 'Proposal created successfully',
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Past Proposals
          const Text(
            'Past Proposals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.check_circle, color: Colors.white),
              ),
              title: const Text('Update UI'),
              subtitle: const Text('Passed 2 days ago'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Proposal Results',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Update UI to new design system'),
                        SizedBox(height: 16),
                        Text('Final Results:'),
                        Text('• Yes: 4,567'),
                        Text('• No: 2,345'),
                        Text('• Abstain: 345'),
                        SizedBox(height: 16),
                        Text('Status: Passed'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.cancel, color: Colors.white),
              ),
              title: const Text('Change Fee Structure'),
              subtitle: const Text('Failed 5 days ago'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Proposal Results',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Change fee structure for markets'),
                        SizedBox(height: 16),
                        Text('Final Results:'),
                        Text('• Yes: 3,456'),
                        Text('• No: 4,567'),
                        Text('• Abstain: 234'),
                        SizedBox(height: 16),
                        Text('Status: Failed'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
