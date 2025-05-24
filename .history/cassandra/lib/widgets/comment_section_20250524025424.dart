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
  List<Map<String, dynamic>> comments = [];
  bool isLoading = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => isLoading = true);
    try {
      final loadedComments = await widget.starknetService.getComments(int.parse(widget.marketId));
      setState(() {
        comments = loadedComments;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading comments: $e')),
      );
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await widget.starknetService.addComment(
        int.parse(widget.marketId),
        _commentController.text,
      );
      _commentController.clear();
      _loadComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteComment(int commentId) async {
    setState(() => isLoading = true);
    try {
      await widget.starknetService.deleteComment(
        int.parse(widget.marketId),
        commentId,
      );
      _loadComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting comment: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _toggleLike(int commentId) async {
    setState(() => isLoading = true);
    try {
      final comment = comments.firstWhere((c) => c['id'] == commentId);
      if (comment['liked'] == true) {
        await widget.starknetService.unlikeComment(
          int.parse(widget.marketId),
          commentId,
        );
      } else {
        await widget.starknetService.likeComment(
          int.parse(widget.marketId),
          commentId,
        );
      }
      _loadComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error toggling like: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: isLoading ? null : _addComment,
              child: const Text('Post'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (comments.isEmpty)
          const Center(child: Text('No comments yet'))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                child: ListTile(
                  title: Text(comment['text']),
                  subtitle: Text(
                    'By: ${comment['user']}\nLikes: ${comment['likes']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          comment['liked'] == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: comment['liked'] == true
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () => _toggleLike(comment['id']),
                      ),
                      if (comment['user'] == widget.userAddress)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteComment(comment['id']),
                        ),
                    ],
                  ),
                ),
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
