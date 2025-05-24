import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SearchModal extends StatelessWidget {
  const SearchModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.vertical(top: Radius.circular(22));
    final neonGradient = LinearGradient(
      colors: [
        theme.colorScheme.primary.withOpacity(0.7),
        theme.colorScheme.secondary.withOpacity(0.7),
        theme.colorScheme.tertiary.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
              color: theme.colorScheme.surface.withOpacity(0.72),
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
                    color: theme.colorScheme.tertiary.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.tertiary.withOpacity(0.18),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search',
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
                Divider(color: theme.dividerColor, height: 1, thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search predictions, users, topics...',
                      prefixIcon: Icon(Icons.search, color: theme.colorScheme.secondary),
                      filled: true,
                      fillColor: theme.colorScheme.background.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Search results will appear here soon!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.secondary,
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
      ),
    );
  }
} 