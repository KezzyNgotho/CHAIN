import 'user_profile.dart';

class Curation {
  final String id;
  final UserProfile curator;
  final String contentType;
  final String contentId;
  final int rating;
  final String comment;
  final DateTime timestamp;
  final int upvotes;
  final int downvotes;
  final bool isFeatured;

  Curation({
    required this.id,
    required this.curator,
    required this.contentType,
    required this.contentId,
    required this.rating,
    required this.comment,
    required this.timestamp,
    required this.upvotes,
    required this.downvotes,
    required this.isFeatured,
  });

  factory Curation.fromJson(Map<String, dynamic> json) {
    return Curation(
      id: json['id'] as String,
      curator: UserProfile.fromJson(json['curator'] as Map<String, dynamic>),
      contentType: json['contentType'] as String,
      contentId: json['contentId'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      upvotes: json['upvotes'] as int,
      downvotes: json['downvotes'] as int,
      isFeatured: json['isFeatured'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'curator': curator.toJson(),
      'contentType': contentType,
      'contentId': contentId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'isFeatured': isFeatured,
    };
  }

  int get netVotes => upvotes - downvotes;
  double get upvotePercentage {
    final total = upvotes + downvotes;
    if (total == 0) return 0;
    return (upvotes * 100 / total);
  }
} 