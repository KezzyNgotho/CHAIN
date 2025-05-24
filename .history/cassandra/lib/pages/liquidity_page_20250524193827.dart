import 'package:flutter/material.dart';
import '../main.dart';
import 'notifications_page.dart';
import 'help_page.dart';

class LiquidityPage extends StatelessWidget {
  const LiquidityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Liquidity',
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
                    'Your Liquidity',
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
                        label: 'Total Value',
                        value: '\$12,345',
                      ),
                      _StatItem(
                        label: 'Fees Earned',
                        value: '\$234',
                      ),
                      _StatItem(
                        label: 'Positions',
                        value: '5',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Active Positions
          const Text(
            'Active Positions',
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
                child: Icon(Icons.analytics, color: Colors.white),
              ),
              title: const Text('ETH/USD'),
              subtitle: const Text('Value: \$5,000'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Position Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ETH/USD Market'),
                        SizedBox(height: 16),
                        Text('Position Value: \$5,000'),
                        Text('Fees Earned: \$45'),
                        Text('APY: 12%'),
                        Text('Added: 30 days ago'),
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
                              title: 'Remove Liquidity',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'Are you sure you want to remove liquidity?'),
                                  SizedBox(height: 16),
                                  Text('You will receive:'),
                                  Text('• \$5,000 in ETH'),
                                  Text('• \$45 in fees'),
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
                                        message:
                                            'Liquidity removed successfully',
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Remove'),
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
                child: Icon(Icons.analytics, color: Colors.white),
              ),
              title: const Text('BTC/USD'),
              subtitle: const Text('Value: \$7,345'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Position Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('BTC/USD Market'),
                        SizedBox(height: 16),
                        Text('Position Value: \$7,345'),
                        Text('Fees Earned: \$89'),
                        Text('APY: 15%'),
                        Text('Added: 45 days ago'),
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
                              title: 'Remove Liquidity',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'Are you sure you want to remove liquidity?'),
                                  SizedBox(height: 16),
                                  Text('You will receive:'),
                                  Text('• \$7,345 in BTC'),
                                  Text('• \$89 in fees'),
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
                                        message:
                                            'Liquidity removed successfully',
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Add Liquidity
          const Text(
            'Add Liquidity',
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
              title: const Text('New Position'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Add Liquidity',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Select Market'),
                        SizedBox(height: 16),
                        Text('• ETH/USD'),
                        Text('• BTC/USD'),
                        Text('• SOL/USD'),
                        Text('• AVAX/USD'),
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
                          showDialog(
                            context: context,
                            builder: (context) => UniversalDialog(
                              title: 'Add Liquidity',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('ETH/USD Market'),
                                  SizedBox(height: 16),
                                  Text('Enter Amount:'),
                                  Text('• Minimum: \$100'),
                                  Text('• Recommended: \$1,000'),
                                  Text('• Maximum: \$10,000'),
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
                                        message: 'Liquidity added successfully',
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Historical Performance
          const Text(
            'Historical Performance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.show_chart, color: Colors.white),
              ),
              title: const Text('Performance Chart'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Performance Chart',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Historical Performance'),
                        SizedBox(height: 16),
                        Text('• Total Value: \$12,345'),
                        Text('• Total Fees: \$234'),
                        Text('• Average APY: 13.5%'),
                        Text('• Best Market: BTC/USD'),
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
