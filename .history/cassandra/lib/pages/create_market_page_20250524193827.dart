import 'package:flutter/material.dart';
import '../main.dart';
import 'notifications_page.dart';
import 'help_page.dart';

class CreateMarketPage extends StatelessWidget {
  const CreateMarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Create Market',
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
          // Market Type
          const Text(
            'Market Type',
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
              title: const Text('Price Prediction'),
              subtitle: const Text('Predict the price of an asset'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Price Prediction',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'Create a market to predict the price of an asset'),
                        SizedBox(height: 16),
                        Text('• Select asset pair'),
                        Text('• Set end time'),
                        Text('• Add initial liquidity'),
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
                              title: 'Select Asset Pair',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Choose an asset pair'),
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
                                        title: 'Set End Time',
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('When should the market end?'),
                                            SizedBox(height: 16),
                                            Text('• 1 day'),
                                            Text('• 1 week'),
                                            Text('• 1 month'),
                                            Text('• Custom'),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    UniversalDialog(
                                                  title: 'Add Liquidity',
                                                  content: const Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text('Initial Liquidity'),
                                                      SizedBox(height: 16),
                                                      Text('• Minimum: \$100'),
                                                      Text(
                                                          '• Recommended: \$1,000'),
                                                      Text(
                                                          '• Maximum: \$10,000'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          UniversalSnackBar(
                                                            message:
                                                                'Market created successfully',
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                        );
                                                      },
                                                      child:
                                                          const Text('Create'),
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
                                  child: const Text('Continue'),
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
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.event, color: Colors.white),
              ),
              title: const Text('Event Outcome'),
              subtitle: const Text('Predict the outcome of an event'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Event Outcome',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Create a market to predict an event outcome'),
                        SizedBox(height: 16),
                        Text('• Enter event details'),
                        Text('• Set possible outcomes'),
                        Text('• Add initial liquidity'),
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
                              title: 'Event Details',
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Enter event information'),
                                  SizedBox(height: 16),
                                  Text('• Title'),
                                  Text('• Description'),
                                  Text('• End time'),
                                  Text('• Outcomes'),
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
                                            Text('Initial Liquidity'),
                                            SizedBox(height: 16),
                                            Text('• Minimum: \$100'),
                                            Text('• Recommended: \$1,000'),
                                            Text('• Maximum: \$10,000'),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                UniversalSnackBar(
                                                  message:
                                                      'Market created successfully',
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
                                  child: const Text('Continue'),
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

          // Market Templates
          const Text(
            'Market Templates',
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
                child: Icon(Icons.analytics, color: Colors.white),
              ),
              title: const Text('ETH/USD Price'),
              subtitle: const Text('Predict ETH price in 7 days'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'ETH/USD Price',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Predict ETH price in 7 days'),
                        SizedBox(height: 16),
                        Text('• Current Price: \$2,500'),
                        Text('• End Time: 7 days'),
                        Text('• Initial Liquidity: \$1,000'),
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
                              message: 'Market created successfully',
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
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.event, color: Colors.white),
              ),
              title: const Text('Election Result'),
              subtitle: const Text('Predict election outcome'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Election Result',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Predict election outcome'),
                        SizedBox(height: 16),
                        Text('• Candidates: A, B, C'),
                        Text('• End Time: Election day'),
                        Text('• Initial Liquidity: \$1,000'),
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
                              message: 'Market created successfully',
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
        ],
      ),
    );
  }
}
