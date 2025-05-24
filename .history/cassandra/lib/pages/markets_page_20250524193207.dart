import 'package:flutter/material.dart';
import '../main.dart';

class MarketsPage extends StatelessWidget {
  const MarketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Markets',
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
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search markets...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Active Markets
          const Text(
            'Active Markets',
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
              subtitle: const Text('Ends in 3 days'),
              trailing: const Text('\$2,500.00'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ETH/USD Price Market'),
                        SizedBox(height: 16),
                        Text('Current Price: \$2,500.00'),
                        Text('Volume: \$1.2M'),
                        Text('24h Change: +5.2%'),
                        Text('End Time: 3 days'),
                        Text('Liquidity: \$500K'),
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
                              title: 'Place Trade',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Trade Details'),
                                  SizedBox(height: 16),
                                  Text('• Amount'),
                                  Text('• Direction'),
                                  Text('• Leverage'),
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
                                        message: 'Trade placed successfully',
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text('Trade'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Trade'),
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
              subtitle: const Text('Ends in 5 days'),
              trailing: const Text('\$45,000.00'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('BTC/USD Price Market'),
                        SizedBox(height: 16),
                        Text('Current Price: \$45,000.00'),
                        Text('Volume: \$2.5M'),
                        Text('24h Change: +3.8%'),
                        Text('End Time: 5 days'),
                        Text('Liquidity: \$1M'),
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
                              title: 'Place Trade',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Trade Details'),
                                  SizedBox(height: 16),
                                  Text('• Amount'),
                                  Text('• Direction'),
                                  Text('• Leverage'),
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
                                        message: 'Trade placed successfully',
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text('Trade'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Trade'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Upcoming Markets
          const Text(
            'Upcoming Markets',
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
                child: Icon(Icons.event, color: Colors.white),
              ),
              title: const Text('Election Result'),
              subtitle: const Text('Starts in 2 days'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Election Result Market'),
                        SizedBox(height: 16),
                        Text('Candidates: A, B, C'),
                        Text('Start Time: 2 days'),
                        Text('End Time: Election day'),
                        Text('Initial Liquidity: \$100K'),
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
                backgroundColor: Colors.orange,
                child: Icon(Icons.sports, color: Colors.white),
              ),
              title: const Text('World Cup Final'),
              subtitle: const Text('Starts in 1 week'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('World Cup Final Market'),
                        SizedBox(height: 16),
                        Text('Teams: A vs B'),
                        Text('Start Time: 1 week'),
                        Text('End Time: Match end'),
                        Text('Initial Liquidity: \$200K'),
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
          const SizedBox(height: 24),

          // Create Market
          const Text(
            'Create Market',
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
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: const Text('New Market'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateMarketPage(),
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
