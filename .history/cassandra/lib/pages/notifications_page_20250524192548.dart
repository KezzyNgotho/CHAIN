import 'package:flutter/material.dart';
import '../main.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Notifications',
        actions: [
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
          // Market Notifications
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.analytics, color: Colors.white),
              ),
              title: const Text('Market Update'),
              subtitle: const Text('ETH/USD price has changed significantly'),
              trailing: const Text('2m ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Update',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ETH/USD price has changed significantly'),
                        SizedBox(height: 16),
                        Text('Previous: \$2,500.00'),
                        Text('Current: \$2,750.00'),
                        Text('Change: +10%'),
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
                backgroundColor: Colors.green,
                child: Icon(Icons.check_circle, color: Colors.white),
              ),
              title: const Text('Market Resolved'),
              subtitle: const Text('BTC/USD market has been resolved'),
              trailing: const Text('1h ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Resolved',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('BTC/USD market has been resolved'),
                        SizedBox(height: 16),
                        Text('Final Price: \$45,000.00'),
                        Text('Your Position: +5.2%'),
                        Text('Reward: 0.5 STRK'),
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
          const SizedBox(height: 16),

          // Governance Notifications
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(Icons.how_to_vote, color: Colors.white),
              ),
              title: const Text('New Proposal'),
              subtitle: const Text('A new governance proposal is available'),
              trailing: const Text('3h ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'New Proposal',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('A new governance proposal is available'),
                        SizedBox(height: 16),
                        Text('Title: Increase Market Fee'),
                        Text(
                            'Description: Increase market fee from 0.1% to 0.2%'),
                        Text('Voting Period: 7 days'),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GovernancePage(),
                            ),
                          );
                        },
                        child: const Text('View Proposal'),
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
                backgroundColor: Colors.orange,
                child: Icon(Icons.notifications_active, color: Colors.white),
              ),
              title: const Text('Proposal Ending Soon'),
              subtitle: const Text('Voting period ends in 24 hours'),
              trailing: const Text('1d ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Proposal Ending Soon',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Voting period ends in 24 hours'),
                        SizedBox(height: 16),
                        Text('Title: Add New Market'),
                        Text('Current Votes: 2,345'),
                        Text('Required: 5,000'),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GovernancePage(),
                            ),
                          );
                        },
                        child: const Text('Vote Now'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // System Notifications
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.info, color: Colors.white),
              ),
              title: const Text('System Update'),
              subtitle: const Text('New features have been added'),
              trailing: const Text('2d ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'System Update',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('New features have been added'),
                        SizedBox(height: 16),
                        Text('• Improved market creation'),
                        Text('• Enhanced liquidity pools'),
                        Text('• New governance features'),
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
