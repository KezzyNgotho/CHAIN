import 'package:flutter/material.dart';
import '../services/starknet_service.dart';
import '../widgets/comment_section.dart';

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
  Map<String, dynamic>? marketDetails;
  bool isLoading = false;
  String error = '';
  final TextEditingController _amountController = TextEditingController();
  bool isYes = true;

  @override
  void initState() {
    super.initState();
    _loadMarketDetails();
  }

  Future<void> _loadMarketDetails() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      // Mock market details for now
      final details = {
        'id': widget.marketId,
        'title': 'Will ETH reach \$5,000 by end of 2024?',
        'description': 'Prediction on Ethereum price movement',
        'category': 'Crypto',
        'endTime': '1735689600', // Dec 31, 2024
        'totalStaked': '1000000000000000000000', // 1000 tokens
        'yesStaked': '700000000000000000000', // 700 tokens
        'noStaked': '300000000000000000000', // 300 tokens
        'status': 0, // 0: Active, 1: Resolved, 2: Cancelled
        'outcome': null,
        'createdBy': '0x123',
        'createdAt': '1711234567',
      };

      setState(() {
        marketDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _stake() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      // Mock staking
      final stakeAmount =
          BigInt.from(double.parse(_amountController.text) * 1e18);
      if (isYes) {
        marketDetails!['yesStaked'] =
            (BigInt.parse(marketDetails!['yesStaked']) + stakeAmount)
                .toString();
      } else {
        marketDetails!['noStaked'] =
            (BigInt.parse(marketDetails!['noStaked']) + stakeAmount).toString();
      }
      marketDetails!['totalStaked'] =
          (BigInt.parse(marketDetails!['yesStaked']) +
                  BigInt.parse(marketDetails!['noStaked']))
              .toString();

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stake placed successfully')),
      );
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMarketDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (marketDetails == null) {
      return const Center(child: Text('No details available'));
    }

    final yesStaked = BigInt.parse(marketDetails!['yesStaked']);
    final noStaked = BigInt.parse(marketDetails!['noStaked']);
    final totalStaked = yesStaked + noStaked;
    final yesPercentage = totalStaked > BigInt.zero
        ? (yesStaked * BigInt.from(100) / totalStaked).toInt()
        : 0;
    final noPercentage = 100 - yesPercentage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Market Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            marketDetails!['title'],
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        _MarketStatusChip(status: marketDetails!['status']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(marketDetails!['description']),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            marketDetails!['category'],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ends: ${DateTime.fromMillisecondsSinceEpoch(int.parse(marketDetails!['endTime']) * 1000).toString().split('.')[0]}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Staking Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Staking Stats',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yes: $yesPercentage%',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: yesPercentage / 100,
                                backgroundColor:
                                    theme.colorScheme.primary.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(yesStaked / BigInt.from(1e18)).toString()} tokens',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No: $noPercentage%',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: noPercentage / 100,
                                backgroundColor:
                                    theme.colorScheme.error.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(noStaked / BigInt.from(1e18)).toString()} tokens',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Place Stake
            if (marketDetails!['status'] == 0) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Place Your Stake',
                        style: theme.textTheme.titleMedium,
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
                          labelText: 'Amount (tokens)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _stake,
                          child: const Text('Stake'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Comments
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

class _MarketStatusChip extends StatelessWidget {
  final int status;

  const _MarketStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String label;
    Color color;

    switch (status) {
      case 0:
        label = 'Active';
        color = theme.colorScheme.primary;
        break;
      case 1:
        label = 'Resolved';
        color = Colors.green;
        break;
      case 2:
        label = 'Cancelled';
        color = theme.colorScheme.error;
        break;
      default:
        label = 'Unknown';
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
