import 'user_profile.dart';

class Market {
  final String id;
  final String question;
  final DateTime endTime;
  final bool resolved;
  final bool? outcome;
  final BigInt yesAmount;
  final BigInt noAmount;
  final BigInt totalStaked;
  final UserProfile creator;
  final DateTime createdAt;

  Market({
    required this.id,
    required this.question,
    required this.endTime,
    required this.resolved,
    this.outcome,
    required this.yesAmount,
    required this.noAmount,
    required this.totalStaked,
    required this.creator,
    required this.createdAt,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'] as String,
      question: json['question'] as String,
      endTime: DateTime.parse(json['endTime'] as String),
      resolved: json['resolved'] as bool,
      outcome: json['outcome'] as bool?,
      yesAmount: BigInt.parse(json['yesAmount'] as String),
      noAmount: BigInt.parse(json['noAmount'] as String),
      totalStaked: BigInt.parse(json['totalStaked'] as String),
      creator: UserProfile.fromJson(json['creator'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'endTime': endTime.toIso8601String(),
      'resolved': resolved,
      'outcome': outcome,
      'yesAmount': yesAmount.toString(),
      'noAmount': noAmount.toString(),
      'totalStaked': totalStaked.toString(),
      'creator': creator.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  double get yesPercentage {
    if (totalStaked == BigInt.zero) return 0;
    return (yesAmount * BigInt.from(100) / totalStaked).toDouble();
  }

  double get noPercentage {
    if (totalStaked == BigInt.zero) return 0;
    return (noAmount * BigInt.from(100) / totalStaked).toDouble();
  }

  bool get isActive => !resolved && DateTime.now().isBefore(endTime);
} 