import 'package:flutter/material.dart';
import '../services/starknet_service.dart';
import 'market_details_screen.dart';
import 'profile_screen.dart';
import 'create_market_screen.dart';

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
      final loadedMarkets = await widget.starknetService.getMarkets();
      setState(() {
        markets = loadedMarkets;
        isLoading = false;
      });
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
            icon: const Icon(Icons.refresh),
            onPressed: _loadMarkets,
          ),
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
              : RefreshIndicator(
                  onRefresh: _loadMarkets,
                  child: ListView.builder(
                    itemCount: markets.length,
                    itemBuilder: (context, index) {
                      final market = markets[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(market['question']),
                          subtitle: Text(
                            'Category: ${market['category']}\nEnds: ${DateTime.fromMillisecondsSinceEpoch(int.parse(market['end_time']) * 1000).toString()}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Yes: ${market['yes_pool']} ETH',
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                'No: ${market['no_pool']} ETH',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MarketDetailsScreen(
                                  marketId: market['id'].toString(),
                                  userAddress: widget.starknetService.userAddress ?? '',
                                  starknetService: widget.starknetService,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateMarketScreen(
                starknetService: widget.starknetService,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
