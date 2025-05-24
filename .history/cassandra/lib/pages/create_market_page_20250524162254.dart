import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateMarketPage extends StatefulWidget {
  const CreateMarketPage({super.key});

  @override
  State<CreateMarketPage> createState() => _CreateMarketPageState();
}

class _CreateMarketPageState extends State<CreateMarketPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  DateTime? _endTime;
  final _initialStakeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    _initialStakeController.dispose();
    super.dispose();
  }

  Future<void> _selectEndTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<void> _createMarket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement market creation logic
      // await starkNetService.createMarket(
      //   _questionController.text,
      //   _endTime!.millisecondsSinceEpoch,
      //   _initialStakeController.text,
      // );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Market created successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating market: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
        elevation: 0,
        title: const Text('Create Market'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Field
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Market Question',
                  hintText: 'What will happen?',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  if (value.length < 10) {
                    return 'Question must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // End Time Field
              ListTile(
                title: const Text('End Time'),
                subtitle: Text(
                  _endTime == null
                      ? 'Select end time'
                      : DateFormat('MMM dd, yyyy HH:mm').format(_endTime!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectEndTime,
              ),
              if (_endTime == null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Please select an end time',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Initial Stake Field
              TextFormField(
                controller: _initialStakeController,
                decoration: const InputDecoration(
                  labelText: 'Initial Stake (STRK)',
                  hintText: 'Enter amount to stake',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an initial stake';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createMarket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Create Market'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 