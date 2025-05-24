import 'package:flutter/material.dart';
import '../main.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Help & Support',
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
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search help topics...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.analytics_outlined,
                  title: 'Create Market',
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
              const SizedBox(width: 16),
              Expanded(
                child: _ActionCard(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Add Liquidity',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LiquidityPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // FAQ Section
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ExpansionTile(
              title: const Text('How do I create a market?'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'To create a market, go to the Markets tab and click the + button. Fill in the market details, including the question, end time, and initial stake. Once created, other users can participate in your market.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ExpansionTile(
              title: const Text('How does liquidity provision work?'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Liquidity providers add funds to the market pool, earning fees from trades. The more liquidity you provide, the more fees you earn. You can add or remove liquidity at any time.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ExpansionTile(
              title: const Text('What is governance?'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Governance allows token holders to propose and vote on changes to the protocol. This includes market parameters, fees, and new features. Each token represents one vote.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Documentation Section
          const Text(
            'Documentation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text('Getting Started'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Getting Started',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Welcome to Cassandra!'),
                        SizedBox(height: 16),
                        Text('1. Connect your wallet'),
                        Text('2. Create or join markets'),
                        Text('3. Provide liquidity'),
                        Text('4. Participate in governance'),
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
              leading: const Icon(Icons.security_outlined),
              title: const Text('Security'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UniversalDialog(
                    title: 'Security',
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Security Best Practices'),
                        SizedBox(height: 16),
                        Text('• Never share your private key'),
                        Text('• Use hardware wallets'),
                        Text('• Enable 2FA'),
                        Text('• Verify transactions'),
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

          // Community Section
          const Text(
            'Community',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.discord),
              title: const Text('Discord'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Open Discord link
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.code),
              title: const Text('GitHub'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Open GitHub link
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('Twitter'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Open Twitter link
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
