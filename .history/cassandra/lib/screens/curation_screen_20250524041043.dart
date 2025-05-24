import 'package:flutter/material.dart';
import 'package:cassandra/services/mock_data_service.dart';
import 'package:cassandra/models/curation.dart';
import 'package:intl/intl.dart';

class CurationScreen extends StatelessWidget {
  const CurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final curations = MockDataService.getCurations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedContent(
                curations.where((c) => c.isFeatured).toList()),
            const SizedBox(height: 16),
            _buildRecentCurations(curations),
            const SizedBox(height: 16),
            _buildNewCurationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedContent(List<Curation> featured) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Content',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...featured.map((curation) => _buildFeaturedCard(curation)),
      ],
    );
  }

  Widget _buildFeaturedCard(Curation curation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${curation.contentType.toUpperCase()}: ${curation.contentId}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Featured',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Curated by ${curation.curator.username}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < curation.rating ? Colors.amber : Colors.grey,
                    size: 20,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  '${curation.rating}/5',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(curation.comment),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM d, y HH:mm').format(curation.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () {
                        // TODO: Implement upvote
                      },
                    ),
                    Text('${curation.upvotes}'),
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      onPressed: () {
                        // TODO: Implement downvote
                      },
                    ),
                    Text('${curation.downvotes}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCurations(List<Curation> curations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Curations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...curations.map((curation) => _buildCurationCard(curation)),
      ],
    );
  }

  Widget _buildCurationCard(Curation curation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${curation.contentType.toUpperCase()}: ${curation.contentId}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () {
                        // TODO: Implement upvote
                      },
                    ),
                    Text('${curation.upvotes}'),
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      onPressed: () {
                        // TODO: Implement downvote
                      },
                    ),
                    Text('${curation.downvotes}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Curated by ${curation.curator.username}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < curation.rating ? Colors.amber : Colors.grey,
                    size: 20,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  '${curation.rating}/5',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(curation.comment),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM d, y HH:mm').format(curation.timestamp),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCurationButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement new curation form
      },
      child: const Text('Create New Curation'),
    );
  }
}
