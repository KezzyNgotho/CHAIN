import 'package:flutter/material.dart';
import '../services/starknet_service.dart';

class CommentSection extends StatefulWidget {
  final String marketId;
  final String userAddress;
  final StarkNetService starknetService;

  const CommentSection({
    Key? key,
    required this.marketId,
    required this.userAddress,
    required this.starknetService,
  }) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    try {
      final comments = await widget.starknetService.getComments(widget.marketId);
      setState(() => _comments = comments);
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    try {
      await widget.starknetService.submitComment(
        _commentController.text,
        widget.marketId,
      );
      _commentController.clear();
      _loadComments();
    } catch (e) {
      // Handle error
    }
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
        if (_isLoading)
          const CircularProgressIndicator()
        else
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
