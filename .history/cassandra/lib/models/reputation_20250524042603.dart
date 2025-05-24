class Reputation {
  final String userId;
  final int totalPoints;
  final int contentPoints;
  final int governancePoints;
  final int curationPoints;
  final int level;
  final List<String> badges;
  final Map<String, int> categoryScores;
  final DateTime lastUpdated;

  Reputation({
    required this.userId,
    required this.totalPoints,
    required this.contentPoints,
    required this.governancePoints,
    required this.curationPoints,
    required this.level,
    required this.badges,
    required this.categoryScores,
    required this.lastUpdated,
  });

  factory Reputation.fromJson(Map<String, dynamic> json) {
    return Reputation(
      userId: json['user_id'],
      totalPoints: json['total_points'],
      contentPoints: json['content_points'],
      governancePoints: json['governance_points'],
      curationPoints: json['curation_points'],
      level: json['level'],
      badges: List<String>.from(json['badges']),
      categoryScores: Map<String, int>.from(json['category_scores']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_points': totalPoints,
      'content_points': contentPoints,
      'governance_points': governancePoints,
      'curation_points': curationPoints,
      'level': level,
      'badges': badges,
      'category_scores': categoryScores,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  double getReputationScore() {
    return (totalPoints / 1000) * 100; // Convert to percentage
  }

  String getLevelTitle() {
    if (level >= 10) return 'Master';
    if (level >= 7) return 'Expert';
    if (level >= 4) return 'Advanced';
    if (level >= 2) return 'Intermediate';
    return 'Beginner';
  }
}
