import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CommentsModal extends StatefulWidget {
  final Map<String, dynamic> prediction;

  const CommentsModal({super.key, required this.prediction});

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isReplying = false;
  String? _replyTo;
  late AnimationController _animationController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _comments = [];
  String _sortBy = 'Top';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _loadComments();
  }

  Future<void> _loadComments() async {
    // Simulate loading comments
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _comments = [
        {
          'id': '1',
          'user': '@crypto_whale',
          'text':
              'This prediction looks solid! I\'ve been tracking similar patterns.',
          'likes': 24,
          'isLiked': false,
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'replies': [
            {
              'id': '1.1',
              'user': '@trader_pro',
              'text': 'Agreed! The technical analysis supports this.',
              'likes': 8,
              'isLiked': false,
              'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
            },
          ],
        },
        {
          'id': '2',
          'user': '@market_wizard',
          'text':
              'I\'m skeptical about this timeline. Market conditions are too volatile.',
          'likes': 15,
          'isLiked': false,
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
          'replies': [],
        },
      ];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _handleLike(String commentId) {
    setState(() {
      final comment = _findComment(commentId);
      if (comment != null) {
        comment['isLiked'] = !(comment['isLiked'] as bool);
        comment['likes'] =
            (comment['likes'] as int) + (comment['isLiked'] as bool ? 1 : -1);
      }
    });
  }

  Map<String, dynamic>? _findComment(String commentId) {
    for (var comment in _comments) {
      if (comment['id'] == commentId) return comment;
      for (var reply in (comment['replies'] as List)) {
        if (reply['id'] == commentId) return reply;
      }
    }
    return null;
  }

  void _handleReply(String commentId) {
    final comment = _findComment(commentId);
    if (comment != null) {
      setState(() {
        _isReplying = true;
        _replyTo = comment['user'] as String;
      });
      _commentController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSubmitComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user': '@your_username',
      'text': _commentController.text.trim(),
      'likes': 0,
      'isLiked': false,
      'timestamp': DateTime.now(),
      'replies': [],
    };

    setState(() {
      if (_isReplying) {
        // Find parent comment and add reply
        for (var comment in _comments) {
          if (comment['user'] == _replyTo) {
            (comment['replies'] as List).add(newComment);
            break;
          }
        }
      } else {
        _comments.add(newComment);
      }
      _commentController.clear();
      _isReplying = false;
      _replyTo = null;
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.vertical(top: Radius.circular(22));

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Color(0xFF181A1A),
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF181A1A),
            borderRadius: borderRadius,
            border: Border.all(width: 1, color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            children: [
              // Drag indicator
              Container(
                margin: const EdgeInsets.only(top: 14, bottom: 8),
                width: 48,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Sort options
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'Sort by:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Top'),
                      selected: _sortBy == 'Top',
                      onSelected: (selected) {
                        if (selected) setState(() => _sortBy = 'Top');
                      },
                      selectedColor: theme.colorScheme.tertiary,
                      backgroundColor: theme.colorScheme.surface.withOpacity(
                        0.3,
                      ),
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        color:
                            _sortBy == 'Top'
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Latest'),
                      selected: _sortBy == 'Latest',
                      onSelected: (selected) {
                        if (selected) setState(() => _sortBy = 'Latest');
                      },
                      selectedColor: theme.colorScheme.tertiary,
                      backgroundColor: theme.colorScheme.surface.withOpacity(
                        0.3,
                      ),
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        color:
                            _sortBy == 'Latest'
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Color(0xFF222222), height: 1, thickness: 1),
              // Comments list
              Expanded(
                child:
                    _isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.tertiary,
                          ),
                        )
                        : _comments.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 48,
                                color: theme.colorScheme.primary.withOpacity(
                                  0.25,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No comments yet',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Be the first to start the conversation!',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: _comments.length,
                          itemBuilder: (context, index) {
                            final comment = _comments[index];
                            return _buildCommentItem(theme, comment);
                          },
                        ),
              ),
              // Comment input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.95),
                  border: Border(
                    top: BorderSide(color: Color(0xFF222222), width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    if (_isReplying)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Replying to $_replyTo',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isReplying = false;
                                  _replyTo = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: theme.colorScheme.primary,
                          child: const Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
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
                              fillColor: theme.colorScheme.background
                                  .withOpacity(0.7),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            style: theme.textTheme.bodyMedium,
                            onSubmitted: (_) => _handleSubmitComment(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: _handleSubmitComment,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem(ThemeData theme, Map<String, dynamic> comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment['user'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getTimeAgo(comment['timestamp'] as DateTime),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment['text'] as String,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed:
                              () => _handleReply(comment['id'] as String),
                          icon: Icon(
                            Icons.reply,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Reply',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton.icon(
                          onPressed: () => _handleLike(comment['id'] as String),
                          icon: Icon(
                            comment['isLiked'] as bool
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text(
                            '${comment['likes']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Replies
          if ((comment['replies'] as List).isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Column(
                children:
                    (comment['replies'] as List).map((reply) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: theme.colorScheme.secondary,
                              child: const Icon(
                                Icons.person_outline,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        reply['user'] as String,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _getTimeAgo(
                                          reply['timestamp'] as DateTime,
                                        ),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.5),
                                              fontSize: 11,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    reply['text'] as String,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      TextButton.icon(
                                        onPressed:
                                            () => _handleReply(
                                              reply['id'] as String,
                                            ),
                                        icon: Icon(
                                          Icons.reply,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Reply',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      TextButton.icon(
                                        onPressed:
                                            () => _handleLike(
                                              reply['id'] as String,
                                            ),
                                        icon: Icon(
                                          reply['isLiked'] as bool
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          '${reply['likes']}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
