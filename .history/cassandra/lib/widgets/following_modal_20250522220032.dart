import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FollowingModal extends StatelessWidget {
  const FollowingModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.vertical(top: Radius.circular(22));
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
            border: Border.all(
              width: 2.5,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 14, bottom: 8),
                width: 48,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0xFF181A1A),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Following',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white.withOpacity(0.5),
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(color: theme.dividerColor, height: 1, thickness: 1),
              Expanded(
                child: Center(
                  child: Text(
                    'Followed users and their predictions will appear here soon!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
