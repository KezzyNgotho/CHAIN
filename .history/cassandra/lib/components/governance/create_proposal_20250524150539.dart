import 'package:flutter/material.dart';
import 'package:starknet/starknet.dart';

class CreateProposal extends StatefulWidget {
  const CreateProposal({Key? key}) : super(key: key);

  @override
  State<CreateProposal> createState() => _CreateProposalState();
}

class _CreateProposalState extends State<CreateProposal> {
  final _starknetService = StarkNetService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stakeController = TextEditingController();
  bool _isCreating = false;

  Future<void> _createProposal() async {
    if (_isCreating) return;

    setState(() {
      _isCreating = true;
    });

    try {
      await _starknetService.createStakingProposal(
        _titleController.text,
        _descriptionController.text,
        _stakeController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proposal created successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create proposal: $e')),
      );
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Proposal'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _stakeController,
              decoration: InputDecoration(
                labelText: 'Required Stake',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isCreating ? null : _createProposal,
              child: Text('Create Proposal'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stakeController.dispose();
    super.dispose();
  }
}
