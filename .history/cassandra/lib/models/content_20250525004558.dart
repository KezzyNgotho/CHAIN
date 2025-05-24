class Content {
  final String id;
  final String title;
  final String description;
  final String author;
  final String category;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;
  final double qualityScore;
  final List<String> tags;
  final bool isVerified;
  final String status; // 'pending', 'approved', 'rejected'

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.category,
    required this.createdAt,
    required this.upvotes,
    required this.downvotes,
    required this.qualityScore,
    required this.tags,
    required this.isVerified,
    required this.status,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      qualityScore: json['quality_score'].toDouble(),
      tags: List<String>.from(json['tags']),
      isVerified: json['is_verified'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'quality_score': qualityScore,
      'tags': tags,
      'is_verified': isVerified,
      'status': status,
    };
  }
}
