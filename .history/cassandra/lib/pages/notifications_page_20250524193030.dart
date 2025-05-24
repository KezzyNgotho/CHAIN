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
          // Today
          const Text(
            'Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.check_circle, color: Colors.white),
              ),
              title: const Text('Trade Executed'),
              subtitle: const Text('Your ETH/USD trade was executed'),
              trailing: const Text('2h ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Trade Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ETH/USD Trade'),
                        SizedBox(height: 16),
                        Text('Amount: \$1,000'),
                        Text('Direction: Long'),
                        Text('Entry Price: \$2,500'),
                        Text('Status: Executed'),
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
                backgroundColor: Colors.blue,
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              title: const Text('Market Update'),
              subtitle: const Text('New market created: BTC/USD'),
              trailing: const Text('5h ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Update',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('New Market Created'),
                        SizedBox(height: 16),
                        Text('Market: BTC/USD'),
                        Text('Type: Price Prediction'),
                        Text('End Time: 7 days'),
                        Text('Initial Liquidity: \$1M'),
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
                              builder: (context) => const MarketsPage(),
                            ),
                          );
                        },
                        child: const Text('View Market'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Yesterday
          const Text(
            'Yesterday',
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
                child: Icon(Icons.warning, color: Colors.white),
              ),
              title: const Text('Price Alert'),
              subtitle: const Text('ETH price dropped 5%'),
              trailing: const Text('1d ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Price Alert',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ETH Price Drop'),
                        SizedBox(height: 16),
                        Text('Current Price: \$2,375'),
                        Text('Change: -5%'),
                        Text('24h Volume: \$1.5M'),
                        Text('Market Cap: \$285B'),
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
                              builder: (context) => const MarketsPage(),
                            ),
                          );
                        },
                        child: const Text('View Market'),
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
                backgroundColor: Colors.purple,
                child: Icon(Icons.account_balance_wallet, color: Colors.white),
              ),
              title: const Text('Deposit Received'),
              subtitle: const Text('Your deposit was confirmed'),
              trailing: const Text('1d ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Deposit Details',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Deposit Confirmed'),
                        SizedBox(height: 16),
                        Text('Amount: \$5,000'),
                        Text('Asset: USDC'),
                        Text('Status: Confirmed'),
                        Text('Time: 24h ago'),
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

          // Earlier
          const Text(
            'Earlier',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.error, color: Colors.white),
              ),
              title: const Text('Trade Failed'),
              subtitle: const Text('Your trade could not be executed'),
              trailing: const Text('3d ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Trade Failed',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Trade Execution Failed'),
                        SizedBox(height: 16),
                        Text('Market: SOL/USD'),
                        Text('Amount: \$2,000'),
                        Text('Reason: Insufficient liquidity'),
                        Text('Time: 3 days ago'),
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
                        child: const Text('Try Again'),
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
              subtitle: const Text('Your market was resolved'),
              trailing: const Text('5d ago'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Resolved',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Market Resolution'),
                        SizedBox(height: 16),
                        Text('Market: Election Result'),
                        Text('Outcome: Candidate A'),
                        Text('Your Position: Won'),
                        Text('Payout: \$1,500'),
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
