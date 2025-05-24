import 'dart:ui';
import 'package:flutter/material.dart';

class CommentModal extends StatefulWidget {
  final String predictionTitle;
  final int commentsCount;
  final VoidCallback? onClose;
  const CommentModal({
    super.key,
    required this.predictionTitle,
    required this.commentsCount,
    this.onClose,
  });

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  final TextEditingController _controller = TextEditingController();
  bool _isReplying = false;
  String? _replyTo;
  bool _postAnonymously = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = const BorderRadius.vertical(top: Radius.circular(32));
    final neonGradient = LinearGradient(
      colors: [
        theme.colorScheme.primary.withOpacity(0.7),
        theme.colorScheme.secondary.withOpacity(0.7),
        theme.colorScheme.tertiary.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: BoxDecoration(
            gradient: neonGradient,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.tertiary.withOpacity(0.25),
                blurRadius: 32,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.85),
                  borderRadius: borderRadius,
                  border: Border.all(
                    width: 2.5,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                child: SafeArea(
                  top: false,
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
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.tertiary.withOpacity(
                                0.18,
                              ),
                              blurRadius: 8,
                            ),
                          ],
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
                            Expanded(
                              child: Text(
                                widget.predictionTitle,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: theme.colorScheme.onSurface,
                                  letterSpacing: 0.5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.5,
                                ),
                              ),
                              onPressed:
                                  widget.onClose ??
                                  () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: theme.dividerColor,
                        height: 1,
                        thickness: 1,
                      ),
                      // Comments count and sort
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.commentsCount} Comments',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.sort,
                                  size: 18,
                                  color: theme.colorScheme.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Sort by:',
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(width: 4),
                                ChoiceChip(
                                  label: const Text('Top'),
                                  selected: true,
                                  onSelected: (_) {},
                                  selectedColor: theme.colorScheme.tertiary,
                                  backgroundColor: theme.colorScheme.surface
                                      .withOpacity(0.3),
                                  labelStyle: theme.textTheme.bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                ChoiceChip(
                                  label: const Text('Latest'),
                                  selected: false,
                                  onSelected: (_) {},
                                  selectedColor: theme.colorScheme.tertiary,
                                  backgroundColor: theme.colorScheme.surface
                                      .withOpacity(0.3),
                                  labelStyle: theme.textTheme.bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: theme.dividerColor,
                        height: 1,
                        thickness: 1,
                      ),
                      // Comments list (placeholder)
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          children: [
                            // TODO: Replace with live threaded comments
                            _buildComment(
                              user: 'User1',
                              text: 'I\'m sure this\'ll win!',
                              likes: 8,
                              isLiked: false,
                            ),
                            _buildComment(
                              user: 'User2',
                              text: 'Crypto market\'s unpredictable',
                              likes: 2,
                              isLiked: false,
                            ),
                          ],
                        ),
                      ),
                      // Sticky input
                      _buildInputBar(theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComment({
    required String user,
    required String text,
    required int likes,
    bool isLiked = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  user[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '@$user',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 18,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(text, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite, color: theme.colorScheme.tertiary, size: 16),
              const SizedBox(width: 4),
              Text('$likes', style: theme.textTheme.bodySmall),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.reply,
                      color: theme.colorScheme.secondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text('Reply', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: theme.dividerColor, height: 1, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.85),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.tertiary.withOpacity(0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText:
                    _isReplying && _replyTo != null
                        ? 'Reply to @$_replyTo'
                        : 'Share your take... 💬',
                filled: true,
                fillColor: theme.colorScheme.background.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.18),
                    width: 1.2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 18,
                ),
              ),
              style: theme.textTheme.bodyMedium,
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    _controller.text.isNotEmpty
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
                boxShadow:
                    _controller.text.isNotEmpty
                        ? [
                          BoxShadow(
                            color: theme.colorScheme.tertiary.withOpacity(0.18),
                            blurRadius: 12,
                          ),
                        ]
                        : [],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.send,
                    color:
                        _controller.text.isNotEmpty
                            ? Colors.white
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
