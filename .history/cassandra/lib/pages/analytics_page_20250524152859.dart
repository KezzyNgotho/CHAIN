import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Time Range Selector
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _TimeRangeTab(
                  label: '24H',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                  color: theme.colorScheme.primary,
                ),
                _TimeRangeTab(
                  label: '7D',
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                  color: theme.colorScheme.secondary,
                ),
                _TimeRangeTab(
                  label: '30D',
                  selected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                  color: theme.colorScheme.tertiary,
                ),
                _TimeRangeTab(
                  label: 'ALL',
                  selected: _selectedTab == 3,
                  onTap: () => setState(() => _selectedTab = 3),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          // Stats Overview
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Total Volume',
                  value: '1.2M STRK',
                  icon: Icons.currency_exchange,
                  color: theme.colorScheme.primary,
                ),
                _StatItem(
                  label: 'Total Trades',
                  value: '5,678',
                  icon: Icons.swap_horiz,
                  color: theme.colorScheme.secondary,
                ),
                _StatItem(
                  label: 'Avg. Price',
                  value: '0.85 STRK',
                  icon: Icons.attach_money,
                  color: theme.colorScheme.tertiary,
                ),
              ],
            ),
          ),
          // Chart Section
          Expanded(
            child: _buildChartSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ChartCard(
          title: 'Price Chart',
          subtitle: 'STRK/USD',
          chart: _buildPlaceholderChart(),
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'Volume Chart',
          subtitle: '24h Trading Volume',
          chart: _buildPlaceholderChart(),
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'Market Depth',
          subtitle: 'Order Book Analysis',
          chart: _buildPlaceholderChart(),
        ),
      ],
    );
  }

  Widget _buildPlaceholderChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Chart Placeholder'),
      ),
    );
  }
}

class _TimeRangeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _TimeRangeTab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? color : color.withOpacity(0.7),
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
          ),
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

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget chart;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // TODO: Show chart options
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            chart,
          ],
        ),
      ),
    );
  }
} 