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
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadMarkets();
  }

  Future<void> _loadMarkets() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      // Mock markets data for now
      final mockMarkets = [
        {
          'id': 1,
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
        },
        {
          'id': 2,
          'title': 'Will Bitcoin ETF approval lead to 20% price increase?',
          'description': 'Impact of ETF approval on BTC price',
          'category': 'Crypto',
          'endTime': '1712534400', // April 8, 2024
          'totalStaked': '500000000000000000000', // 500 tokens
          'yesStaked': '400000000000000000000', // 400 tokens
          'noStaked': '100000000000000000000', // 100 tokens
          'status': 1, // Resolved
          'outcome': true,
          'createdBy': '0x456',
          'createdAt': '1711234567',
        },
      ];

      setState(() {
        markets = mockMarkets;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _createMarket() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const CreateMarketDialog(),
    );

    if (result != null) {
      try {
        setState(() {
          isLoading = true;
          error = '';
        });

        // Mock creating a new market
        final newMarket = {
          'id': markets.length + 1,
          'title': result['title']!,
          'description': result['description']!,
          'category': result['category']!,
          'endTime': result['endTime']!,
          'totalStaked': '0',
          'yesStaked': '0',
          'noStaked': '0',
          'status': 0,
          'outcome': null,
          'createdBy': widget.starknetService.userAddress,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        };

        setState(() {
          markets.insert(0, newMarket);
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
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
              onPressed: _loadMarkets,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

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
      body: markets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No markets available',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createMarket,
                    child: const Text('Create Market'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: markets.length,
              itemBuilder: (context, index) {
                final market = markets[index];
                final yesStaked = BigInt.parse(market['yesStaked']);
                final noStaked = BigInt.parse(market['noStaked']);
                final totalStaked = yesStaked + noStaked;
                final yesPercentage = totalStaked > BigInt.zero
                    ? (yesStaked * BigInt.from(100) / totalStaked).toInt()
                    : 0;
                final noPercentage = 100 - yesPercentage;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                market['title'],
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            _MarketStatusChip(status: market['status']),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(market['description']),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                market['category'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Ends: ${DateTime.fromMillisecondsSinceEpoch(int.parse(market['endTime']) * 1000).toString().split('.')[0]}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
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
                                    backgroundColor: theme.colorScheme.primary
                                        .withOpacity(0.2),
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
                                    backgroundColor: theme.colorScheme.error
                                        .withOpacity(0.2),
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
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createMarket,
        child: const Icon(Icons.add),
      ),
    );
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

class CreateMarketDialog extends StatefulWidget {
  const CreateMarketDialog({super.key});

  @override
  State<CreateMarketDialog> createState() => _CreateMarketDialogState();
}

class _CreateMarketDialogState extends State<CreateMarketDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Crypto';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Market'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: const [
                  DropdownMenuItem(value: 'Crypto', child: Text('Crypto')),
                  DropdownMenuItem(value: 'Sports', child: Text('Sports')),
                  DropdownMenuItem(value: 'Politics', child: Text('Politics')),
                  DropdownMenuItem(
                      value: 'Entertainment', child: Text('Entertainment')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(
                  _selectedDate.toString().split('.')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'description': _descriptionController.text,
                'category': _selectedCategory,
                'endTime':
                    (_selectedDate.millisecondsSinceEpoch ~/ 1000).toString(),
              });
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
