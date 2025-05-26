import 'package:flutter/material.dart';
import '../services/starknet_service.dart';
import 'market_details_screen.dart';
import 'profile_screen.dart';

class MarketListScreen extends StatefulWidget {
  final StarkNetService starknetService;

  const MarketListScreen({
    Key? key,
    required this.starknetService,
  }) : super(key: key);

  @override
  State<MarketListScreen> createState() => _MarketListScreenState();
}

class _MarketListScreenState extends State<MarketListScreen> {
  List<Map<String, dynamic>> markets = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMarkets();
  }

  Future<void> _loadMarkets() async {
    setState(() => isLoading = true);
    try {
      // TODO: Implement getMarkets in StarkNetService
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading markets: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Markets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    starknetService: widget.starknetService,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : markets.isEmpty
              ? const Center(child: Text('No markets available'))
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: markets.length,
                  itemBuilder: (context, index) {
                    final market = markets[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListTile(
                        title: Text(market['question']),
                        subtitle: Text(
                          'Ends: ${market['endTime']}',
                        ),
                        trailing: Text(
                          'Total: ${market['totalStaked']} ETH',
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MarketDetailsScreen(
                                marketId: market['id'],
                                userAddress: market['userAddress'],
                                starknetService: widget.starknetService,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement create market
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create market coming soon!'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
