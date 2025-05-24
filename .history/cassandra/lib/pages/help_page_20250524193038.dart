import 'package:flutter/material.dart';
import '../main.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Help',
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
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Getting Started
          const Text(
            'Getting Started',
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
                child: Icon(Icons.school, color: Colors.white),
              ),
              title: const Text('Tutorial'),
              subtitle: const Text('Learn how to use the app'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Tutorial',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Welcome to Cassandra!'),
                        SizedBox(height: 16),
                        Text('1. Create an account'),
                        Text('2. Deposit funds'),
                        Text('3. Browse markets'),
                        Text('4. Place trades'),
                        Text('5. Monitor positions'),
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
                child: Icon(Icons.account_balance_wallet, color: Colors.white),
              ),
              title: const Text('Deposits & Withdrawals'),
              subtitle: const Text('How to manage your funds'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Deposits & Withdrawals',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Managing Your Funds'),
                        SizedBox(height: 16),
                        Text('Deposits:'),
                        Text('• Connect your wallet'),
                        Text('• Select asset'),
                        Text('• Enter amount'),
                        SizedBox(height: 8),
                        Text('Withdrawals:'),
                        Text('• Select asset'),
                        Text('• Enter amount'),
                        Text('• Confirm transaction'),
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

          // Trading
          const Text(
            'Trading',
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
              title: const Text('Market Types'),
              subtitle: const Text('Understanding different markets'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Market Types',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Available Markets'),
                        SizedBox(height: 16),
                        Text('Price Prediction:'),
                        Text('• Predict asset prices'),
                        Text('• Set end time'),
                        Text('• Add liquidity'),
                        SizedBox(height: 8),
                        Text('Event Outcome:'),
                        Text('• Predict event results'),
                        Text('• Multiple outcomes'),
                        Text('• Time-based resolution'),
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
                child: Icon(Icons.trending_up, color: Colors.white),
              ),
              title: const Text('Placing Trades'),
              subtitle: const Text('How to trade on markets'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Placing Trades',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Trading Guide'),
                        SizedBox(height: 16),
                        Text('1. Select market'),
                        Text('2. Choose direction'),
                        Text('3. Enter amount'),
                        Text('4. Set leverage'),
                        Text('5. Confirm trade'),
                        SizedBox(height: 8),
                        Text('Tips:'),
                        Text('• Start small'),
                        Text('• Use stop-loss'),
                        Text('• Monitor positions'),
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

          // Support
          const Text(
            'Support',
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
                child: Icon(Icons.help, color: Colors.white),
              ),
              title: const Text('FAQ'),
              subtitle: const Text('Frequently asked questions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'FAQ',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Common Questions'),
                        SizedBox(height: 16),
                        Text('Q: How do I create a market?'),
                        Text('A: Go to Create Market page'),
                        SizedBox(height: 8),
                        Text('Q: What are the fees?'),
                        Text('A: 0.1% per trade'),
                        SizedBox(height: 8),
                        Text('Q: How are markets resolved?'),
                        Text('A: Based on final price/outcome'),
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
                child: Icon(Icons.support_agent, color: Colors.white),
              ),
              title: const Text('Contact Support'),
              subtitle: const Text('Get help from our team'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Contact Support',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Support Channels'),
                        SizedBox(height: 16),
                        Text('Email: support@cassandra.com'),
                        Text('Discord: discord.gg/cassandra'),
                        Text('Twitter: @cassandra'),
                        Text('Telegram: t.me/cassandra'),
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
