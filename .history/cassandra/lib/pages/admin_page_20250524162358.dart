import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool _isLoading = false;
  final _reasonController = TextEditingController();
  final _affectedContractsController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _affectedContractsController.dispose();
    super.dispose();
  }

  Future<void> _handleEmergencyAction(bool activate) async {
    if (_reasonController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement emergency action
      // if (activate) {
      //   await starkNetService.activateEmergency(
      //     _reasonController.text,
      //     _affectedContractsController.text,
      //   );
      // } else {
      //   await starkNetService.deactivateEmergency();
      // }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              activate
                  ? 'Emergency mode activated'
                  : 'Emergency mode deactivated',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
        elevation: 0,
        title: const Text('Admin Controls'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.2),
                    theme.colorScheme.secondary.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Status',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(
                        label: 'Active Operators',
                        value: '5',
                        icon: Icons.security,
                        color: theme.colorScheme.primary,
                      ),
                      _StatItem(
                        label: 'Rate Limits',
                        value: 'Active',
                        icon: Icons.speed,
                        color: theme.colorScheme.secondary,
                      ),
                      _StatItem(
                        label: 'Emergency',
                        value: 'Inactive',
                        icon: Icons.warning,
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Emergency Controls
            Text(
              'Emergency Controls',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                hintText: 'Enter reason for emergency action',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _affectedContractsController,
              decoration: const InputDecoration(
                labelText: 'Affected Contracts',
                hintText: 'Enter affected contract addresses (comma-separated)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Emergency Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => _handleEmergencyAction(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Activate Emergency'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => _handleEmergencyAction(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Deactivate Emergency'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Rate Limit Controls
            Text(
              'Rate Limit Controls',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _RateLimitCard(
              title: 'Market Creation',
              currentLimit: '5 per hour',
              onAdjust: () {
                // TODO: Implement rate limit adjustment
              },
            ),
            const SizedBox(height: 8),
            _RateLimitCard(
              title: 'Staking',
              currentLimit: '10 per hour',
              onAdjust: () {
                // TODO: Implement rate limit adjustment
              },
            ),
            const SizedBox(height: 8),
            _RateLimitCard(
              title: 'Proposals',
              currentLimit: '2 per day',
              onAdjust: () {
                // TODO: Implement rate limit adjustment
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

class _RateLimitCard extends StatelessWidget {
  final String title;
  final String currentLimit;
  final VoidCallback onAdjust;

  const _RateLimitCard({
    required this.title,
    required this.currentLimit,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentLimit,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onAdjust,
            ),
          ],
        ),
      ),
    );
  }
}
