import 'package:flutter/material.dart';
import 'package:cassandra/services/mock_data_service.dart';
import 'package:cassandra/models/market.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final markets = MockDataService.getMarkets();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filters
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActiveMarkets(markets),
            const SizedBox(height: 24),
            _buildResolvedMarkets(markets),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new market creation
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActiveMarkets(List<Market> markets) {
    final activeMarkets = markets.where((m) => m.isActive).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Markets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...activeMarkets.map((market) => _buildMarketCard(market)),
      ],
    );
  }

  Widget _buildResolvedMarkets(List<Market> markets) {
    final resolvedMarkets = markets.where((m) => m.resolved).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resolved Markets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...resolvedMarkets.map((market) => _buildMarketCard(market)),
      ],
    );
  }

  Widget _buildMarketCard(Market market) {
    final dateFormat = DateFormat('MMM d, y');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    market.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildMarketStatus(market),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Created by ${market.creator.username}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildMarketInfo('End Date', dateFormat.format(market.endTime)),
            _buildMarketInfo('Total Staked', '${market.totalStaked} tokens'),
            const SizedBox(height: 16),
            _buildVotingProgress(market),
            const SizedBox(height: 16),
            if (market.isActive)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement stake yes
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Stake Yes'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement stake no
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Stake No'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketStatus(Market market) {
    Color color;
    String text;

    if (market.resolved) {
      color = market.outcome == true ? Colors.green : Colors.red;
      text = market.outcome == true ? 'Yes' : 'No';
    } else {
      color = Colors.blue;
      text = 'Active';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildMarketInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildVotingProgress(Market market) {
    final yesPercentage = market.yesPercentage;
    final noPercentage = market.noPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Yes: ${market.yesAmount} tokens'),
            Text('No: ${market.noAmount} tokens'),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: yesPercentage / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Yes: ${yesPercentage.toStringAsFixed(1)}% | No: ${noPercentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
