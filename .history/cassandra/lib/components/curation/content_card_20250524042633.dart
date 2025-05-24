import 'package:flutter/material.dart';
import '../../models/content.dart';

class ContentCard extends StatelessWidget {
  final Content content;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onReport;
  final VoidCallback onShare;

  const ContentCard({
    Key? key,
    required this.content,
    required this.onUpvote,
    required this.onDownvote,
    required this.onReport,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    content.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (content.isVerified)
                  Icon(Icons.verified, color: Colors.blue),
              ],
            ),
            SizedBox(height: 8),
            Text(
              content.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: content.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_upward),
                      onPressed: onUpvote,
                      color: Colors.green,
                    ),
                    Text('${content.upvotes}'),
                    IconButton(
                      icon: Icon(Icons.arrow_downward),
                      onPressed: onDownvote,
                      color: Colors.red,
                    ),
                    Text('${content.downvotes}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: onShare,
                    ),
                    IconButton(
                      icon: Icon(Icons.flag),
                      onPressed: onReport,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'By ${content.author}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Quality Score: ${content.qualityScore.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 