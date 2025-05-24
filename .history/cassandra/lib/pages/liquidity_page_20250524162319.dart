import 'package:flutter/material.dart';

class LiquidityPage extends StatefulWidget {
  const LiquidityPage({super.key});

  @override
  State<LiquidityPage> createState() => _LiquidityPageState();
}

class _LiquidityPageState extends State<LiquidityPage> {
  final _amountController = TextEditingController();
  bool _isLoading = false;
  bool _isProviding = true; // true for provide, false for remove

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleLiquidityAction() async {
    if (_amountController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement liquidity action
      // if (_isProviding) {
      //   await starkNetService.provideLiquidity(_amountController.text);
      // } else {
      //   await starkNetService.removeLiquidity(_amountController.text);
      // }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isProviding
                  ? 'Liquidity provided successfully'
                  : 'Liquidity removed successfully',
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
        title: const Text('Liquidity Management'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pool Stats
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
                    'Pool Statistics',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(
                        label: 'Total Liquidity',
                        value: '1,234,567 STRK',
                        icon: Icons.account_balance_wallet,
                        color: theme.colorScheme.primary,
                      ),
                      _StatItem(
                        label: 'APY',
                        value: '12.5%',
                        icon: Icons.trending_up,
                        color: theme.colorScheme.secondary,
                      ),
                      _StatItem(
                        label: 'Providers',
                        value: '123',
                        icon: Icons.people,
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionToggle(
                      label: 'Provide',
                      selected: _isProviding,
                      onTap: () => setState(() => _isProviding = true),
                      icon: Icons.add_circle_outline,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: _ActionToggle(
                      label: 'Remove',
                      selected: !_isProviding,
                      onTap: () => setState(() => _isProviding = false),
                      icon: Icons.remove_circle_outline,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Amount Input
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: '${_isProviding ? 'Provide' : 'Remove'} Amount (STRK)',
                hintText: 'Enter amount',
                prefixIcon: const Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLiquidityAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isProviding
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_isProviding ? 'Provide Liquidity' : 'Remove Liquidity'),
              ),
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

class _ActionToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const _ActionToggle({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? color : color.withOpacity(0.5),
              size: 18,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected ? color : color.withOpacity(0.7),
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
} 