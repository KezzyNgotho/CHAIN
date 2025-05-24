import 'package:flutter/material.dart';
import '../components/content/content_card.dart';
import '../services/starknet_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final StarkNetService _starkNetService = StarkNetService();
  List<Map<String, dynamic>> _markets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkets();
  }

  Future<void> _loadMarkets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final markets = await _starkNetService.getMarkets();
      setState(() {
        _markets = markets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load markets: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadMarkets,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMarkets,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _markets.length,
                itemBuilder: (context, index) {
                  final market = _markets[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ContentCard(
                      title: market['question'],
                      endTime: DateTime.fromMillisecondsSinceEpoch(
                        int.parse(market['endTime']),
                      ),
                      yesAmount: market['yesAmount'],
                      noAmount: market['noAmount'],
                      onStake: (isYes, amount) async {
                        try {
                          await _starkNetService.stake(
                            market['id'],
                            isYes,
                            amount,
                          );
                          _loadMarkets(); // Refresh after staking
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to stake: $e')),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
} 