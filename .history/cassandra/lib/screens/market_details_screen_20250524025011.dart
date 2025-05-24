import 'package:flutter/material.dart';
import '../services/starknet_service.dart';
import '../widgets/comment_section.dart';

class MarketDetailsScreen extends StatefulWidget {
  final int marketId;
  final String userAddress;
  final StarkNetService starknetService;

  const MarketDetailsScreen({
    Key? key,
    required this.marketId,
    required this.userAddress,
    required this.starknetService,
  }) : super(key: key);

  @override
  State<MarketDetailsScreen> createState() => _MarketDetailsScreenState();
}

class _MarketDetailsScreenState extends State<MarketDetailsScreen> {
  Map<String, dynamic>? marketDetails;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMarketDetails();
  }

  Future<void> _loadMarketDetails() async {
    setState(() => isLoading = true);
    try {
      final details = await widget.starknetService.getPredictionDetails(widget.marketId.toString());
      setState(() {
        marketDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading market details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : marketDetails == null
              ? const Center(child: Text('No market details available'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Market ID: ${widget.marketId}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text('Yes Pool: ${marketDetails!['yesPool']}'),
                              Text('No Pool: ${marketDetails!['noPool']}'),
                              Text('Total Staked: ${marketDetails!['totalStaked']}'),
                              Text('End Time: ${marketDetails!['endTime']}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: CommentSection(
                        marketId: widget.marketId,
                        userAddress: widget.userAddress,
                        starknetService: widget.starknetService,
                      ),
                    ),
                  ],
                ),
    );
  }
} 