import 'package:flutter/material.dart';
import '../main.dart';

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
          // Active Proposals
          Card(
            child: ListTile(
              title: const Text('Increase Market Fee'),
              subtitle: const Text('Proposed by: 0x1234...5678'),
              trailing: const Text('2 days left'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Proposal Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Proposal Information'),
                        SizedBox(height: 16),
                        Text('Title: Increase Market Fee'),
                        Text(
                            'Description: Increase market fee from 0.1% to 0.2%'),
                        Text('Votes For: 1,234'),
                        Text('Votes Against: 567'),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            UniversalSnackBar(
                              message: 'Vote submitted successfully',
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
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Add New Market'),
              subtitle: const Text('Proposed by: 0x8765...4321'),
              trailing: const Text('5 days left'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Proposal Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Proposal Information'),
                        SizedBox(height: 16),
                        Text('Title: Add New Market'),
                        Text('Description: Add SOL/USD market'),
                        Text('Votes For: 2,345'),
                        Text('Votes Against: 678'),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            UniversalSnackBar(
                              message: 'Vote submitted successfully',
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => UniversalBottomSheet(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create Proposal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        UniversalSnackBar(
                          message: 'Proposal created successfully',
                          action: SnackBarAction(
                            label: 'View',
                            onPressed: () {
                              // TODO: Navigate to proposal details
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('Create Proposal'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
