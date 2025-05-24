class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final int points;
  final String icon;
  final bool isSecret;
  final List<String> requirements;
  final DateTime? unlockedAt;
  final int progress;
  final int target;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.points,
    required this.icon,
    required this.isSecret,
    required this.requirements,
    this.unlockedAt,
    required this.progress,
    required this.target,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      points: json['points'],
      icon: json['icon'],
      isSecret: json['is_secret'],
      requirements: List<String>.from(json['requirements']),
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.parse(json['unlocked_at'])
          : null,
      progress: json['progress'],
      target: json['target'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'points': points,
      'icon': icon,
      'is_secret': isSecret,
      'requirements': requirements,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'progress': progress,
      'target': target,
    };
  }

  bool get isUnlocked => unlockedAt != null;
  double get progressPercentage => (progress / target) * 100;
}
