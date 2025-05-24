import 'package:flutter/material.dart';
import '../services/starknet_service.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _starknetService = StarkNetService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _predictions = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadPredictions();
  }

  Future<void> _loadPredictions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // Mock predictions data
      final predictions = [
        {
          'id': 1,
          'title': 'Will ETH reach $5,000 by end of 2024?',
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
        _predictions = predictions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createPrediction() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const CreatePredictionDialog(),
    );

    if (result != null) {
      try {
        setState(() {
          _isLoading = true;
          _error = '';
        });

        // Mock creating a new prediction
        final newPrediction = {
          'id': _predictions.length + 1,
          'title': result['title']!,
          'description': result['description']!,
          'category': result['category']!,
          'endTime': result['endTime']!,
          'totalStaked': '0',
          'yesStaked': '0',
          'noStaked': '0',
          'status': 0,
          'outcome': null,
          'createdBy': _starknetService.userAddress,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        };

        setState(() {
          _predictions.insert(0, newPrediction);
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _stakeOnPrediction(int predictionId, bool stake) async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // Mock staking on a prediction
      final prediction = _predictions.firstWhere((p) => p['id'] == predictionId);
      final stakeAmount = BigInt.from(10e18); // 10 tokens

      if (stake) {
        prediction['yesStaked'] = (BigInt.parse(prediction['yesStaked']) + stakeAmount).toString();
      } else {
        prediction['noStaked'] = (BigInt.parse(prediction['noStaked']) + stakeAmount).toString();
      }
      prediction['totalStaked'] = (BigInt.parse(prediction['yesStaked']) + BigInt.parse(prediction['noStaked'])).toString();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPredictions,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Create Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Predictions',
                style: theme.textTheme.headlineMedium,
              ),
              ElevatedButton.icon(
                onPressed: _createPrediction,
                icon: const Icon(Icons.add),
                label: const Text('New Prediction'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Predictions List
          if (_predictions.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No predictions yet',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                final yesStaked = BigInt.parse(prediction['yesStaked']);
                final noStaked = BigInt.parse(prediction['noStaked']);
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
                                prediction['title'],
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            _PredictionStatusChip(status: prediction['status']),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(prediction['description']),
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
                                prediction['category'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Ends: ${DateTime.fromMillisecondsSinceEpoch(int.parse(prediction['endTime']) * 1000).toString().split('.')[0]}',
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
                                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
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
                                    backgroundColor: theme.colorScheme.error.withOpacity(0.2),
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
                        if (prediction['status'] == 0) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _stakeOnPrediction(prediction['id'], true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                  child: const Text('Stake Yes'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _stakeOnPrediction(prediction['id'], false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                  child: const Text('Stake No'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PredictionStatusChip extends StatelessWidget {
  final int status;

  const _PredictionStatusChip({required this.status});

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

class CreatePredictionDialog extends StatefulWidget {
  const CreatePredictionDialog({super.key});

  @override
  State<CreatePredictionDialog> createState() => _CreatePredictionDialogState();
}

class _CreatePredictionDialogState extends State<CreatePredictionDialog> {
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
      title: const Text('Create Prediction'),
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
                  DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
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
                'endTime': (_selectedDate.millisecondsSinceEpoch ~/ 1000).toString(),
              });
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
} 