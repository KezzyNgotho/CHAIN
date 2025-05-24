import 'package:flutter/material.dart';
import '../components/reputation/reputation_card.dart';
import '../models/reputation.dart';

class ReputationScreen extends StatefulWidget {
  const ReputationScreen({Key? key}) : super(key: key);

  @override
  State<ReputationScreen> createState() => _ReputationScreenState();
}

class _ReputationScreenState extends State<ReputationScreen> {
  Reputation? _reputation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReputation();
  }

  Future<void> _loadReputation() async {
    // TODO: Implement reputation loading from backend
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reputation'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _reputation == null
              ? Center(child: Text('No reputation data available'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ReputationCard(reputation: _reputation!),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How to Earn Points',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 16),
                            _buildPointInfo(
                              context,
                              'Content Creation',
                              'Earn points by creating high-quality content',
                              Icons.article,
                            ),
                            _buildPointInfo(
                              context,
                              'Content Curation',
                              'Earn points by upvoting and downvoting content',
                              Icons.thumb_up,
                            ),
                            _buildPointInfo(
                              context,
                              'Governance',
                              'Earn points by participating in governance',
                              Icons.gavel,
                            ),
                            _buildPointInfo(
                              context,
                              'Community',
                              'Earn points by helping other users',
                              Icons.people,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPointInfo(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 