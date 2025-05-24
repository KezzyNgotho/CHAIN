import 'package:flutter/material.dart';
import '../main.dart';

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
          // Pool List
          Card(
            child: ListTile(
              title: const Text('ETH/USD Pool'),
              subtitle: const Text('Total Value: \$1.2M'),
              trailing: const Text('APY: 12.5%'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Pool Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Pool Information'),
                        SizedBox(height: 16),
                        Text('Total Value: \$1.2M'),
                        Text('Your Share: \$50,000'),
                        Text('APY: 12.5%'),
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
          Card(
            child: ListTile(
              title: const Text('BTC/USD Pool'),
              subtitle: const Text('Total Value: \$2.5M'),
              trailing: const Text('APY: 15.2%'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Pool Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Pool Information'),
                        SizedBox(height: 16),
                        Text('Total Value: \$2.5M'),
                        Text('Your Share: \$75,000'),
                        Text('APY: 15.2%'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => UniversalBottomSheet(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Liquidity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        UniversalSnackBar(
                          message: 'Liquidity added successfully',
                          action: SnackBarAction(
                            label: 'View',
                            onPressed: () {
                              // TODO: Navigate to pool details
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('Add Liquidity'),
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
