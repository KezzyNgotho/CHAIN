import 'package:flutter/material.dart';
import '../components/achievements/achievement_card.dart';
import '../models/achievement.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final List<Achievement> _achievements = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Content',
    'Governance',
    'Curation',
    'Community',
  ];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    // TODO: Implement achievements loading from backend
    setState(() {
      _isLoading = false;
    });
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(achievement.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(achievement.description),
              SizedBox(height: 16),
              Text(
                'Requirements:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8),
              ...achievement.requirements.map((req) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16),
                      SizedBox(width: 8),
                      Text(req),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 16),
              Text(
                'Reward: ${achievement.points} points',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_categories[index]),
                        selected: _categories[index] == _selectedCategory,
                        onTap: () {
                          setState(() {
                            _selectedCategory = _categories[index];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _achievements.length,
              itemBuilder: (context, index) {
                final achievement = _achievements[index];
                return AchievementCard(
                  achievement: achievement,
                  onTap: () => _showAchievementDetails(achievement),
                );
              },
            ),
    );
  }
}
