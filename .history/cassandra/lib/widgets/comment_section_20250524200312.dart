import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final String marketId;

  const CommentSection({
    Key? key,
    required this.marketId,
  }) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.add({
        'user': 'User',
        'text': _commentController.text,
        'timestamp': DateTime.now().toString(),
      });
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: 'Add a comment...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitComment,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final comment = _comments[index];
            return ListTile(
              title: Text(comment['user'] ?? 'Anonymous'),
              subtitle: Text(comment['text'] ?? ''),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
