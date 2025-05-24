import 'package:flutter/material.dart';

class StakeModal extends StatelessWidget {
  final String stakeOn;

  const StakeModal({super.key, required this.stakeOn});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Stake on $stakeOn', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle stake action
              Navigator.pop(context);
            },
            child: const Text('Confirm Stake'),
          ),
        ],
      ),
    );
  }
}
