import 'package:flutter/material.dart';
import '../../models/reputation.dart';

class ReputationCard extends StatelessWidget {
  final Reputation reputation;

  const ReputationCard({
    Key? key,
    required this.reputation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reputation',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  reputation.getLevelTitle(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: reputation.getReputationScore() / 100,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 8),
            Text(
              'Total Score: ${reputation.totalPoints}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            _buildScoreRow(
              context,
              'Content',
              reputation.contentPoints,
              Icons.article,
            ),
            _buildScoreRow(
              context,
              'Governance',
              reputation.governancePoints,
              Icons.gavel,
            ),
            _buildScoreRow(
              context,
              'Curation',
              reputation.curationPoints,
              Icons.rate_review,
            ),
            SizedBox(height: 16),
            Text(
              'Badges',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: reputation.badges.map((badge) {
                return Chip(
                  label: Text(badge),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Category Scores',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            ...reputation.categoryScores.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(entry.value.toString()),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(
    BuildContext context,
    String label,
    int score,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Text(label),
          Spacer(),
          Text(score.toString()),
        ],
      ),
    );
  }
}
