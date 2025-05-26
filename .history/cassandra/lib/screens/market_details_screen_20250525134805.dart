import 'package:flutter/material.dart';
import '../widgets/comment_section.dart';
import '../services/starknet_service.dart';

class MarketDetailsScreen extends StatefulWidget {
  final String marketId;
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
  Map<String, dynamic>? predictionDetails;
  bool isLoading = false;
  final TextEditingController _amountController = TextEditingController();
  bool isYes = true;

  @override
  void initState() {
    super.initState();
    _loadPredictionDetails();
  }

  Future<void> _loadPredictionDetails() async {
    setState(() => isLoading = true);
    try {
      final details =
          await widget.starknetService.getMarket(int.parse(widget.marketId));
      setState(() {
        predictionDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading prediction details: $e')),
      );
    }
  }

  Future<void> _stake() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final amount = _amountController.text;
      final txHash = await widget.starknetService.placeBet(
        int.parse(widget.marketId),
        amount,
        isYes,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction sent successfully! Hash: $txHash')),
      );

      // Refresh market details after successful stake
      await _loadPredictionDetails();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error staking: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPredictionDetails,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : predictionDetails == null
              ? const Center(child: Text('No details available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Market Status',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  'Question: ${predictionDetails!['question']}'),
                              Text(
                                  'Category: ${predictionDetails!['category']}'),
                              Text(
                                  'Yes Pool: ${predictionDetails!['yes_pool']} ETH'),
                              Text(
                                  'No Pool: ${predictionDetails!['no_pool']} ETH'),
                              Text(
                                  'Total Staked: ${predictionDetails!['total_staked']} ETH'),
                              Text(
                                'End Time: ${DateTime.fromMillisecondsSinceEpoch(int.parse(predictionDetails!['end_time']) * 1000).toString()}',
                              ),
                              Text(
                                'Status: ${predictionDetails!['resolved'] ? 'Resolved' : 'Active'}',
                              ),
                              if (predictionDetails!['resolved'])
                                Text(
                                  'Outcome: ${predictionDetails!['outcome'] ? 'Yes' : 'No'}',
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!predictionDetails!['resolved'] &&
                          !predictionDetails!['is_cancelled'])
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Place Your Stake',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: const Text('Yes'),
                                        value: true,
                                        groupValue: isYes,
                                        onChanged: (value) {
                                          setState(() => isYes = value!);
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: const Text('No'),
                                        value: false,
                                        groupValue: isYes,
                                        onChanged: (value) {
                                          setState(() => isYes = value!);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _amountController,
                                  decoration: const InputDecoration(
                                    labelText: 'Amount (ETH)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _stake,
                                    child: isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text('Stake'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      CommentSection(
                        marketId: widget.marketId,
                        userAddress: widget.userAddress,
                        starknetService: widget.starknetService,
                      ),
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
