class UserProfile {
  final String id;
  final String username;
  final String bio;
  final String avatar;
  final Map<String, String> socialLinks;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isVerified;
  final int verificationLevel;
  final int totalCurated;
  final int curationScore;
  final BigInt governancePower;
  final int reputation;
  final int totalPredictions;
  final int successfulPredictions;
  final BigInt totalStaked;
  final BigInt totalRewards;

  UserProfile({
    required this.id,
    required this.username,
    required this.bio,
    required this.avatar,
    required this.socialLinks,
    required this.createdAt,
    required this.lastUpdated,
    required this.isVerified,
    required this.verificationLevel,
    required this.totalCurated,
    required this.curationScore,
    required this.governancePower,
    required this.reputation,
    required this.totalPredictions,
    required this.successfulPredictions,
    required this.totalStaked,
    required this.totalRewards,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      bio: json['bio'] as String,
      avatar: json['avatar'] as String,
      socialLinks: Map<String, String>.from(json['socialLinks'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isVerified: json['isVerified'] as bool,
      verificationLevel: json['verificationLevel'] as int,
      totalCurated: json['totalCurated'] as int,
      curationScore: json['curationScore'] as int,
      governancePower: BigInt.parse(json['governancePower'] as String),
      reputation: json['reputation'] as int,
      totalPredictions: json['totalPredictions'] as int,
      successfulPredictions: json['successfulPredictions'] as int,
      totalStaked: BigInt.parse(json['totalStaked'] as String),
      totalRewards: BigInt.parse(json['totalRewards'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'bio': bio,
      'avatar': avatar,
      'socialLinks': socialLinks,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'isVerified': isVerified,
      'verificationLevel': verificationLevel,
      'totalCurated': totalCurated,
      'curationScore': curationScore,
      'governancePower': governancePower.toString(),
      'reputation': reputation,
      'totalPredictions': totalPredictions,
      'successfulPredictions': successfulPredictions,
      'totalStaked': totalStaked.toString(),
      'totalRewards': totalRewards.toString(),
    };
  }

  double get successRate {
    if (totalPredictions == 0) return 0;
    return successfulPredictions / totalPredictions;
  }
}
