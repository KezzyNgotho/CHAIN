import 'package:flutter/material.dart';
import '../../models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;

  const AchievementCard({
    Key? key,
    required this.achievement,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: achievement.isUnlocked ? onTap : null,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    IconData(
                      int.parse(achievement.icon),
                      fontFamily: 'MaterialIcons',
                    ),
                    size: 32,
                    color: achievement.isUnlocked
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.isSecret && !achievement.isUnlocked
                              ? '???'
                              : achievement.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (achievement.isUnlocked)
                          Text(
                            'Unlocked ${_formatDate(achievement.unlockedAt!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  if (achievement.isUnlocked)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                ],
              ),
              if (!achievement.isSecret || achievement.isUnlocked) ...[
                SizedBox(height: 8),
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: achievement.progressPercentage / 100,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  color: achievement.isUnlocked
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress: ${achievement.progress}/${achievement.target}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${achievement.points} points',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
