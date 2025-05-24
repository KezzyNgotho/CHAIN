import 'user_profile.dart';

class Proposal {
  final String id;
  final UserProfile proposer;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final BigInt yesVotes;
  final BigInt noVotes;
  final BigInt requiredStake;
  final int status; // 0: Active, 1: Passed, 2: Failed, 3: Executed
  final bool executed;

  Proposal({
    required this.id,
    required this.proposer,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.yesVotes,
    required this.noVotes,
    required this.requiredStake,
    required this.status,
    required this.executed,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'] as String,
      proposer: UserProfile.fromJson(json['proposer'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      yesVotes: BigInt.parse(json['yesVotes'] as String),
      noVotes: BigInt.parse(json['noVotes'] as String),
      requiredStake: BigInt.parse(json['requiredStake'] as String),
      status: json['status'] as int,
      executed: json['executed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proposer': proposer.toJson(),
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'yesVotes': yesVotes.toString(),
      'noVotes': noVotes.toString(),
      'requiredStake': requiredStake.toString(),
      'status': status,
      'executed': executed,
    };
  }

  bool get isActive => status == 0 && !executed;
  bool get hasPassed => status == 1;
  bool get hasFailed => status == 2;
  bool get isExecuted => status == 3;

  double get yesPercentage {
    final total = yesVotes + noVotes;
    if (total == BigInt.zero) return 0;
    return (yesVotes * BigInt.from(100) / total).toDouble();
  }

  double get noPercentage {
    final total = yesVotes + noVotes;
    if (total == BigInt.zero) return 0;
    return (noVotes * BigInt.from(100) / total).toDouble();
  }

  Duration get remainingTime {
    if (!isActive) return Duration.zero;
    final now = DateTime.now();
    if (now.isAfter(endTime)) return Duration.zero;
    return endTime.difference(now);
  }
} 