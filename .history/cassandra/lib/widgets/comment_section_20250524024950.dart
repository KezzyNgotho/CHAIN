import 'package:flutter/material.dart';
import 'package:starknet/starknet.dart';
import '../services/starknet_service.dart';
import 'comment_widget.dart';

class CommentSection extends StatefulWidget {
  final int marketId;
  final String userAddress;
  final StarknetService starknetService;

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
  List<Map<String, dynamic>> comments = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => isLoading = true);
    try {
      final result = await widget.starknetService.getComments(widget.marketId);
      setState(() {
        comments = result;
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
    if (_commentController.text.isEmpty) return;

    setState(() => isLoading = true);
    try {
      await widget.starknetService.addComment(
        widget.marketId,
        _commentController.text,
      );
      _commentController.clear();
      await _loadComments();
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    }
  }

  Future<void> _deleteComment(int commentId) async {
    setState(() => isLoading = true);
    try {
      await widget.starknetService.deleteComment(widget.marketId, commentId);
      await _loadComments();
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting comment: $e')),
      );
    }
  }

  Future<void> _likeComment(int commentId) async {
    setState(() => isLoading = true);
    try {
      await widget.starknetService.likeComment(widget.marketId, commentId);
      await _loadComments();
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error liking comment: $e')),
      );
    }
  }

  Future<void> _unlikeComment(int commentId) async {
    setState(() => isLoading = true);
    try {
      await widget.starknetService.unlikeComment(widget.marketId, commentId);
      await _loadComments();
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error unliking comment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: isLoading ? null : _addComment,
              ),
            ],
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return CommentWidget(
                  text: comment['text'],
                  userAddress: comment['user'],
                  likes: comment['likes'],
                  commentId: comment['id'],
                  marketId: widget.marketId,
                  isOwner: comment['user'] == widget.userAddress,
                  onLike: () => _likeComment(comment['id']),
                  onUnlike: () => _unlikeComment(comment['id']),
                  onDelete: () => _deleteComment(comment['id']),
                );
              },
            ),
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
