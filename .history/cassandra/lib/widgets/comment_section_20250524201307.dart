import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CommentSection extends StatefulWidget {
  final String marketId;
  final Function(String)? onError;
  final Function(bool)? onLoading;

  const CommentSection({
    Key? key,
    required this.marketId,
    this.onError,
    this.onLoading,
  }) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    widget.onLoading?.call(true);
    try {
      // TODO: Implement API call to load comments
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay
      setState(() {
        _comments = [
          {
            'id': '1',
            'user': 'User 1',
            'text': 'This is a great prediction!',
            'timestamp':
                DateTime.now().subtract(const Duration(hours: 1)).toString(),
            'likes': 5,
            'isOwner': false,
          },
          {
            'id': '2',
            'user': 'User 2',
            'text': 'I agree with this analysis.',
            'timestamp':
                DateTime.now().subtract(const Duration(hours: 2)).toString(),
            'likes': 3,
            'isOwner': true,
          },
        ];
      });
    } catch (e) {
      widget.onError?.call('Failed to load comments: ${e.toString()}');
    } finally {
      widget.onLoading?.call(false);
    }
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) {
      widget.onError?.call('Please enter a comment');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      // TODO: Implement API call to submit comment
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay

      setState(() {
        _comments.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'user': 'Current User',
          'text': _commentController.text,
          'timestamp': DateTime.now().toString(),
          'likes': 0,
          'isOwner': true,
        });
      });
      _commentController.clear();
    } catch (e) {
      widget.onError?.call('Failed to post comment: ${e.toString()}');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleLike(String commentId) async {
    try {
      // TODO: Implement API call to like comment
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulated delay

      setState(() {
        final commentIndex = _comments.indexWhere((c) => c['id'] == commentId);
        if (commentIndex != -1) {
          _comments[commentIndex]['likes'] =
              (_comments[commentIndex]['likes'] as int) + 1;
        }
      });
    } catch (e) {
      widget.onError?.call('Failed to like comment: ${e.toString()}');
    }
  }

  Future<void> _handleDelete(String commentId) async {
    try {
      // TODO: Implement API call to delete comment
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulated delay

      setState(() {
        _comments.removeWhere((c) => c['id'] == commentId);
      });
    } catch (e) {
      widget.onError?.call('Failed to delete comment: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: _comments.isEmpty
              ? Center(
                  child: Text(
                    'No comments yet',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment['user'] ?? 'Anonymous',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (comment['isOwner'] == true)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () =>
                                        _handleDelete(comment['id']),
                                    color: theme.colorScheme.error,
                                    iconSize: 20,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comment['text'] ?? '',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateTime.parse(comment['timestamp'] ??
                                          DateTime.now().toString())
                                      .toString()
                                      .split('.')[0],
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.thumb_up_outlined),
                                      onPressed: () =>
                                          _handleLike(comment['id']),
                                      iconSize: 20,
                                    ),
                                    Text(
                                      '${comment['likes']}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn().slideX(
                          begin: 0.2,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: _isSubmitting
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : const Icon(Icons.send),
                onPressed: _isSubmitting ? null : _submitComment,
                color: theme.colorScheme.primary,
              ),
            ],
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
