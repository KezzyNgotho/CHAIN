import 'package:flutter/material.dart';
import '../constants/user_avatars.dart';

class AvatarCircle extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool isOnline;
  final VoidCallback? onTap;
  final int avatarIndex;

  const AvatarCircle({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.isOnline = false,
    this.onTap,
    this.avatarIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  UserAvatars.getAvatarColor(avatarIndex),
                  UserAvatars.getAvatarColor(avatarIndex).withOpacity(0.7),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildFallbackAvatar(context),
                    )
                  : _buildFallbackAvatar(context),
            ),
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Icon(
        UserAvatars.getRandomAvatar(),
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
} 