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
  List<Map<String, dynamic>> comments = [];
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      // Mock comments data for now
      final mockComments = [
        {
          'id': 1,
          'content': 'I think ETH will definitely reach $5,000 by end of 2024!',
          'userAddress': '0x123',
          'createdAt': '1711234567',
          'likes': 5,
          'replies': [
            {
              'id': 2,
              'content': 'Agreed! The market is looking bullish.',
              'userAddress': '0x456',
              'createdAt': '1711234667',
              'likes': 2,
            },
          ],
        },
        {
          'id': 3,
          'content': 'Not so sure about that, there might be a bear market.',
          'userAddress': '0x789',
          'createdAt': '1711234767',
          'likes': 3,
          'replies': [],
        },
      ];

      setState(() {
        comments = mockComments;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      // Mock adding a comment
      final newComment = {
        'id': comments.length + 1,
        'content': _commentController.text,
        'userAddress': widget.userAddress,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'likes': 0,
        'replies': [],
      };

      setState(() {
        comments.insert(0, newComment);
        _commentController.clear();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _addReply(Map<String, dynamic> comment) async {
    final reply = await showDialog<String>(
      context: context,
      builder: (context) => _ReplyDialog(),
    );

    if (reply != null) {
      setState(() {
        isLoading = true;
        error = '';
      });

      try {
        // Mock adding a reply
        final newReply = {
          'id': comment['replies'].length + 1,
          'content': reply,
          'userAddress': widget.userAddress,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'likes': 0,
        };

        setState(() {
          comment['replies'].add(newReply);
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleLike(Map<String, dynamic> comment) async {
    setState(() {
      comment['likes'] = (comment['likes'] as int) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadComments,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments',
              style: theme.textTheme.titleMedium,
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
                IconButton(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (comments.isEmpty)
              Center(
                child: Text(
                  'No comments yet. Be the first to comment!',
                  style: theme.textTheme.bodyLarge,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return _CommentCard(
                    comment: comment,
                    onReply: () => _addReply(comment),
                    onLike: () => _toggleLike(comment),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class _CommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;
  final VoidCallback onReply;
  final VoidCallback onLike;

  const _CommentCard({
    required this.comment,
    required this.onReply,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    comment['userAddress'].substring(2, 4).toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${comment['userAddress'].substring(0, 6)}...${comment['userAddress'].substring(comment['userAddress'].length - 4)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(comment['createdAt']),
                        ).toString().split('.')[0],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment['content']),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: onLike,
                  icon: const Icon(Icons.thumb_up_outlined),
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                Text(
                  comment['likes'].toString(),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: onReply,
                  child: const Text('Reply'),
                ),
              ],
            ),
            if (comment['replies'].isNotEmpty) ...[
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comment['replies'].length,
                itemBuilder: (context, index) {
                  final reply = comment['replies'][index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 32, top: 8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: theme.colorScheme.secondary,
                                  child: Text(
                                    reply['userAddress'].substring(2, 4).toUpperCase(),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSecondary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${reply['userAddress'].substring(0, 6)}...${reply['userAddress'].substring(reply['userAddress'].length - 4)}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(reply['createdAt']),
                                        ).toString().split('.')[0],
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(reply['content']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReplyDialog extends StatefulWidget {
  @override
  State<_ReplyDialog> createState() => _ReplyDialogState();
}

class _ReplyDialogState extends State<_ReplyDialog> {
  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Reply'),
      content: TextField(
        controller: _replyController,
        decoration: const InputDecoration(
          hintText: 'Enter your reply...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_replyController.text.isNotEmpty) {
              Navigator.pop(context, _replyController.text);
            }
          },
          child: const Text('Reply'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}
