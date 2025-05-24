class UserProfile {
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

  UserProfile({
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
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}
