import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String text;
  final String userAddress;
  final int likes;
  final int commentId;
  final int marketId;
  final bool isOwner;
  final Function() onLike;
  final Function() onUnlike;
  final Function() onDelete;

  const CommentWidget({
    Key? key,
    required this.text,
    required this.userAddress,
    required this.likes,
    required this.commentId,
    required this.marketId,
    required this.isOwner,
    required this.onLike,
    required this.onUnlike,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${userAddress.substring(0, 6)}...${userAddress.substring(userAddress.length - 4)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                if (isOwner)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(text),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: likes > 0 ? Colors.blue : Colors.grey,
                  ),
                  onPressed: likes > 0 ? onUnlike : onLike,
                ),
                Text('$likes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
